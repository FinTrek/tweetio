# // Copyright (C) 2019 Brendan Knapp
# // This file is part of tweetio.
# // 
# // This program is free software: you can redistribute it and/or modify
# // it under the terms of the GNU General Public License as published by
# // the Free Software Foundation, either version 3 of the License, or
# // (at your option) any later version.
# // 
# // This program is distributed in the hope that it will be useful,
# // but WITHOUT ANY WARRANTY; without even the implied warranty of
# // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# // GNU General Public License for more details.
# // 
# // You should have received a copy of the GNU General Public License
# // along with this program.  If not, see <https://www.gnu.org/licenses/>.

.distribute_vec_attrs <- function(x) {
  lapply(x, function(.x) {
    if (is.atomic(.x)) lapply(.x, `attributes<-`, attributes(.x))
    else .x
  })
}

.prep_edge_attrs <- function(edges) {
  edges <- as.list(edges)
  
  edge_attr_names <- names(edges)[-(1:2)]
  init_vals_eval <- .distribute_vec_attrs(edges[edge_attr_names])
  
  list(
    names_eval = rep(
      list(as.vector(edge_attr_names, mode = "list")),
      times = length(edges[[1L]])
    ),
    vals_eval = .mapply(list, init_vals_eval, NULL)
  )
}

.prep_vertex_attrs <- function(vertices) {
  vertices <- as.list(vertices)
  vertices[-1L] <- .distribute_vec_attrs(vertices[-1L])
  vertices
}


#' Convert Various Objects to `network` graphs.
#' 
#' @param x Tweet data frame or `proto_net`.
#' @template param-target_class
#' @template param-all_status_data
#' @template param-all_user_data
#' @template param-dots
#' 
#' @seealso [as_proto_net()], [as_tweet_igraph()]
#' 
#' @template author-bk
#' 
#' @examples 
#' path_to_tweet_file <- example_tweet_file()
#' tweet_df <- read_tweets(path_to_tweet_file)
#' 
#' tweet_df %>% 
#'   as_tweet_network()
#'   
#' tweet_df %>% 
#'   as_proto_net() %>% 
#'   as_tweet_network()
#'   
#' tweet_df %>% 
#'   as_tweet_network(all_status_data = TRUE)
#'   
#' tweet_df %>% 
#'   as_tweet_network(all_user_data = TRUE)
#' 
#' @export
as_tweet_network <- function(x, 
                             target_class = target_class,
                             all_status_data = all_status_data,
                             all_user_data = all_user_data, 
                             ...) {
  UseMethod("as_tweet_network")
}


#' @rdname as_tweet_network
#' 
#' @importFrom data.table := %chin%
#' @importFrom utils getFromNamespace
#' 
#' @export
as_tweet_network.proto_net <- function(x, ...) {
  if (!requireNamespace("network", quietly = TRUE)) {
    .stop("The {network} package is required for this funcitonality.")
  }

  # silence R CMD Check NOTE =============================================================
  name <- NULL
  is_actor <- NULL
  # ======================================================================================
  
  if (attr(x, "target_class", exact = TRUE) == "user") {
    bipartite_arg <- FALSE
    directed_arg <- TRUE
    loops_arg <- TRUE
  } else {
    bipartite_arg <- length(unique(x$edges[[1L]])) # n "actors" (users)
    directed_arg <- FALSE
    loops_arg <- FALSE
  }
  
  edge_attrs <- .prep_edge_attrs(x$edges)
  
  out_sources <- lapply(x$edges[[1L]], match, x$nodes[[1L]])
  out_targets <- lapply(x$edges[[2L]], match, x$nodes[[1L]])

  out <- network::network.initialize(
    n = nrow(x$nodes),
    directed = directed_arg,
    hyper = FALSE,
    loops = loops_arg,
    multiple = TRUE,
    bipartite = bipartite_arg
  )
  
  out <- network::add.edges.network(
    x = out,
    tail = out_sources,
    head = out_targets,
    names.eval = edge_attrs$names_eval,
    vals.eval = edge_attrs$vals_eval
  )
  
  out <- network::set.vertex.attribute(
    x = out,
    attrname = c("vertex.names", names(x$nodes)[-1L]),
    value = .prep_vertex_attrs(x$nodes)
  )
  
  out
}


#' @rdname as_tweet_network
#' 
#' @export
as_tweet_network.data.frame <- function(x, 
                                        target_class = c("user", "hashtag", 
                                                         "url", "media"),
                                        all_status_data = FALSE,
                                        all_user_data = FALSE,
                                        ...) {
  init <- as_proto_net(x, 
                       target_class = target_class,
                       all_status_data = all_status_data,
                       all_user_data = all_user_data,
                       as_tibble = FALSE,
                       ...)
  
  as_tweet_network(init)
}

