#!/usr/bin/env Rscript

# get bash arguments
args <- commandArgs(trailingOnly = TRUE)

change_exp <- function(amount_rate, chance_rate) {

    tmp <- read.csv("/home/game/mon/tmp.txt",
                    header = FALSE)

    # takes care of trailing commas
    tmp <- tmp[, !names(tmp) %in% "V4"]

    if (ncol(tmp) == 3) {

        tmp$V2 <- tmp$V2 * amount_rate
        tmp$V3 = ifelse(tmp$V3 * amount_rate > 1000, 1000, tmp$V3 * chance_rate)

        tmp2 <- paste0("(", tmp$V1, ", ", tmp$V2, ", ", tmp$V3, "),", "\n")
        tmp2[length(tmp2)] <- stringi::stri_replace_last(tmp2[length(tmp2)], fixed = ",\n", "")

        sink("/home/game/mon/outfile.txt")
        cat(paste0("Inventory = {"),
            tmp2, paste0("}"), paste0("\n"),
            sep = "")
        sink()

    }
}

change_exp(amount_rate = as.numeric(args[1]), 
           chance_rate = as.numeric(args[2]))
