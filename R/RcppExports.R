# Generated by using Rcpp::compileAttributes() -> do not edit by hand
# Generator token: 10BE3573-1514-4C36-9D1C-5A225CD40393

is_valid_bbox <- function(bbox_coords, lon_lat = TRUE) {
    .Call(`_tweetio_is_valid_bbox`, bbox_coords, lon_lat)
}

prep_bbox <- function(bbox_coords, lon_lat = TRUE) {
    .Call(`_tweetio_prep_bbox`, bbox_coords, lon_lat)
}

read_tweets_impl <- function(file_path, verbose = FALSE) {
    .Call(`_tweetio_read_tweets_impl`, file_path, verbose)
}

unnest_entities_impl <- function(tracker, source, target, col_names) {
    .Call(`_tweetio_unnest_entities_impl`, tracker, source, target, col_names)
}

unnest_entities2_impl <- function(tracker, source, target, col_names) {
    .Call(`_tweetio_unnest_entities2_impl`, tracker, source, target, col_names)
}

