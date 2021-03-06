#' Create a list of trait definitions (a thesaurus of traits)
#' 
#' Create a trait thesaurus object for use as a reference object/lookup table of
#' traits within function `standardize.traits()`.
#' 
#' @param ... multiple objects of class 'trait' (produced by function
#'   `as.trait()`) or a data.frame containing columns according to the terms
#'   provided by https://ecologicaltraitdata.github.io/ETS/#terms-for-thesauri.
#' @param replace named character vector, with new names as values, and old names as names.
#'   
#' @return a list of formalized objects of class 'trait', as returned by
#'   function as.trait().
#'   
#' @details the object class 'trait' comprises necessary information to map a
#'   trait name to a  trait definition, a target unit and a globally unique
#'   identifier. The thesaurus will be used in function 'standardize.traits()'
#'   to apply unit conversion and factor level harmonization.
#'   
#' @export
#' @importFrom reshape rename
#' 
#' @examples
#' 
#' # provide traitlist by defining individual traits using function `as.trait()`:
#' 
#' traitlist <- as.thesaurus(body_length = as.trait("body_length", expectedUnit = "mm", 
#'     valueType = "numeric", 
#'     identifier = "http://t-sita.cesab.org/BETSI_vizInfo.jsp?trait=Body_length"), 
#'   antenna_length = as.trait("antenna_length", expectedUnit = "mm", 
#'     valueType = "numeric", 
#'     identifier = "http://t-sita.cesab.org/BETSI_vizInfo.jsp?trait=Antenna_length"),
#'   metafemur_length = as.trait("metafemur_length", expectedUnit = "mm", 
#'     valueType = "numeric", 
#'     identifier = "http://t-sita.cesab.org/BETSI_vizInfo.jsp?trait=Femur_length")
#' )
#' 
#' # provide traitlist from data frame object: 
#' 
#' as.thesaurus(data.frame(
#'   trait = c("body_length", "antenna_length", "metafemur_length", "eyewidth_corr"),
#'   expectedUnit = "mm",
#'   valueType = "numeric",
#'   traitDescription = c("body length in mm", "length of antenna in mm", "length of metafemur in mm", "eye width in mm"), 
#'   identifier = c("http://t-sita.cesab.org/BETSI_vizInfo.jsp?trait=Body_length", 
#'     "http://t-sita.cesab.org/BETSI_vizInfo.jsp?trait=Antenna_length", 
#'     "http://t-sita.cesab.org/BETSI_vizInfo.jsp?trait=Femur_length", 
#'     "http://t-sita.cesab.org/BETSI_vizInfo.jsp?trait=Eye_diameter"
#'     )
#' )
#' )
#' 
#' # provide traitlist from remote archive with renaming
#' 
#' traits1 <- as.thesaurus(read.csv("https://raw.githubusercontent.com/EcologicalTraitData/TraitDataList/master/traitdatastandard_traitlist.csv"), 
#' replace = c(traitID = "identifier", 
#'             traitName = "trait",
#'             traitUnit = "expectedUnit",
#'             Comments = "comments") 
#' )

as.thesaurus <- function(...,
                         replace = NULL
                         ) {
  if( "data.frame" %in% class(..1)) {
    input <- ..1
    if(!is.null(replace)) input <- reshape::rename(input, replace)
    out <- lapply(split(input, f = input$trait, drop= TRUE), function(y) do.call(as.trait, y))
    
  }
  if("trait" %in% class(..1)) {
    out <- list(...)
  }
  if(! "trait" %in% class(..1) && ! "data.frame" %in% class(..1)) stop("no valid input for creating a thesaurus")
  
  class(out) <- c("thesaurus", "list")
  return(out)
}

#' @export
print.thesaurus <- function(x) {
  out <- do.call(rbind, lapply(x,data.frame))
  print(out)
}

#' Create a trait definition
#'
#' Creating an object containing a standardised trait definition according to
#' the Ecological Traitdata Standard. Parameters correspond to the definition at
#' \url{http://ecologicaltraitdata.github.io/ETS/#terms-for-thesauri}.
#'
#' @param trait A character string, providing an intuitive, human-readable trait
#'   name.
#' @param identifier Unique identifier for the trait, ideally unique and stable
#'   URI which identify the source of the trait definition.
#' @param traitDescription A short, unambiguous definition of the trait. May
#'   refer to a method of measurement.
#' @param comments Details and Examples for clarification of the trait
#'   definition.
#' @param broaderTerm One or several terms that enclose the trait definition.
#' @param narrowerTerm One or several terms that are enclosed by the trait
#'   definition.
#' @param expectedUnit the unit expected for measurement entries.
#' @param maxAllowedValue An upper boundary for accepted numerical values.
#' @param minAllowedValue A lower boundary for accepted numerical values.
#' @param factorLevels A comma separated list of terms comprising the
#'   constrained vocabulary for categorical traits or ordinal binary traits.
#' @param valueType the type of trait values. Possible entries are 'numeric',
#'   'integer', 'categorical', 'logical', or 'character'.
#' @param relationSource A character string providing a full bibliographic
#'   reference to the trait definition (giving title, author, year and
#'   publication).
#' @param version A character string containing the version number of the
#'   referenced definition (e.g. "v1.2"), if applicable.
#' @param author A character string or object of class 'person' (as created by
#'   `as.person()`) attributing the author(s) of the trait definition.
#' @param ...
#'
#' @export
#'
#' @examples
#'
#' body_length <- as.trait("body_length", expectedUnit = "mm", valueType = "numeric",
#'   identifier = "http://t-sita.cesab.org/BETSI_vizInfo.jsp?trait=Body_length",
#'   traitDescription = "The known longest dimension of the physical structure of organisms",
#'   relationSource = "Maggenti and Maggenti, 2005",
#'   broaderTerm = "http://t-sita.cesab.org/BETSI_vizInfo.jsp?trait=Body_dimension"
#'   )
#' 
as.trait <- function(
  trait,
  identifier = NA,
  broaderTerm = NA,
  narrowerTerm = NA,
  expectedUnit = NA,
  maxAllowedValue = NA,
  minAllowedValue = NA,
  factorLevels = NA,
  valueType = NA,
  traitDescription = NA,
  comments = NA,
  relationSource = NA,
  version = NA,
  author = NA,
  ...
) {
  out <- list(trait = trait,
              identifier = identifier,
              broaderTerm = broaderTerm,
              narrowerTerm = narrowerTerm,
              expectedUnit = expectedUnit,
              maxAllowedValue = maxAllowedValue,
              minAllowedValue = minAllowedValue,
              factorLevels = factorLevels,
              valueType = valueType,
              traitDescription = traitDescription,
              comments = comments,
              relationSource = relationSource,
              version = version,
              author = author
              )
  class(out) <- c("trait", "list")
  return(out)
}

#' @export
print.trait <- function(x) {
  out <- do.call(rbind, lapply(x,data.frame))
  print(out)
}


#print.trait <- function(x) {
#  cat("traitName:")
#}