% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/network.R
\name{as_tweet_network}
\alias{as_tweet_network}
\alias{as_tweet_network.proto_net}
\alias{as_tweet_network.data.frame}
\title{Convert Various Objects to \code{network} graphs.}
\usage{
as_tweet_network(
  x,
  target_class = target_class,
  all_status_data = all_status_data,
  all_user_data = all_user_data,
  ...
)

\method{as_tweet_network}{proto_net}(x, ...)

\method{as_tweet_network}{data.frame}(
  x,
  target_class = c("user", "hashtag", "url", "media"),
  all_status_data = FALSE,
  all_user_data = FALSE,
  ...
)
}
\arguments{
\item{x}{Tweet data frame or \code{proto_net}.}

\item{target_class}{\code{character(1L)}, Default: \code{"user"}. The class of nodes to use as
the second half of each dyad (target/to/head). See Details.}

\item{all_status_data}{\code{logical(1L)}, Default: \code{FALSE}. Whether to attach all relevant
status data to the \code{edges} data frame, which can then be used as edge attributes for
downstream tasks.}

\item{all_user_data}{\code{logical(1L)}, Default: \code{FALSE}. Whether to attach all relevant
user data to the \code{nodes} data frame, which can then be uses as node attributes for
downstream tasks.}

\item{...}{Arguments passed to or from other methods.}
}
\description{
Convert Various Objects to \code{network} graphs.
}
\examples{
path_to_tweet_file <- example_tweet_file()
tweet_df <- read_tweets(path_to_tweet_file)

tweet_df \%>\% 
  as_tweet_network()
  
tweet_df \%>\% 
  as_proto_net() \%>\% 
  as_tweet_network()
  
tweet_df \%>\% 
  as_tweet_network(all_status_data = TRUE)
  
tweet_df \%>\% 
  as_tweet_network(all_user_data = TRUE)

}
\seealso{
\code{\link[=as_proto_net]{as_proto_net()}}, \code{\link[=as_tweet_igraph]{as_tweet_igraph()}}
}
\author{
Brendan Knapp \email{brendan.g.knapp@nps.edu}
}
