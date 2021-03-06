#' Generates samples of different sizes
#'
#' This function draws samples of various sizes from a population.
#'
#' @param pop the virtual population as a tibble
#' @param reps the number of replication for each sample size as an integer value
#' @param sample_size the sample size for each one of the samples as an array
#'
#' @return a tibble containing the sample numbers and sample values
#' tibble columns are replicate, string from pop, size and rep_size
#' rep_size will contain repeated number of reps, used for plotting in other functions
#'
#' @importFrom magrittr %>%
#' @export
#'
#' @examples
#' pop <- generate_virtual_pop(100, "Variable", rnorm, 0, 1)
#' samples <- draw_samples(pop, 3, c(1, 10))
draw_samples <- function(pop, reps, sample_size){

    #Check population input is tibble with at least one value
    if(nrow(pop) <= 0 || typeof(pop) != 'list') {
        stop("Population input is not a valid tibble")
    }

    #Check number of reps is an integer
    if((reps - round(reps)) != 0) {
        stop("Number of replications input must be an integer value")
    }

    #Check number of reps is not an array
    if(length(reps) != 1) {
        stop("Number of replications input must be a single value")
    }

    #Check number of reps is positive
    if(reps <= 0 ){
        stop("Number of replications must be greater than 0")
    }

    #Check all values in sample size array are integers
    for (i in sample_size){
        if((i - round(i)) != 0){
            stop("At least one value in sample size array is not an integer value")
        }
    }

    #Create empty list to contain samples
    samples <- list()

    #Fill samples object per inputs
    for (ss in 1:length(sample_size)){
        for (rep in 1:length(reps)){
            samples[[ss * length(reps) + rep]] <- pop %>%
                infer::rep_sample_n(size = sample_size[ss], reps = reps[rep], replace = TRUE) %>%
                dplyr::mutate(size = sample_size[ss], rep_size = reps[rep])
        }
    }
  return(dplyr::bind_rows(samples))
}
