# General settings

## General directories
root.dir <- here::here()
data.dir <- file.path(root.dir, "data")
data.raw.dir  <- file.path(data.dir, "raw")
data.processed.dir  <- file.path(data.dir, "processed")

functions.dir <- file.path(root.dir, "functions")




p.label.ln <- function(.l) {bquote("ln"~.(.l)) }
p.label.log <- function(.l, base=10) {bquote("log"[.(base)]~.(.l)) }

p.label.time.h <- bquote("Time"~(h))
p.label.od <- function(.w) { bquote("OD"[.(.w)]) }
p.label.od.730 <-bquote("OD"[730])
p.label.ln.od.730 <-bquote("ln OD"[730])
p.label.od.ln <- function(.w) { p.label.ln(p.label.od(.w)) }
p.label.fl <- "Fluorescence (AU)"
p.label.fl.od <- bquote("Fluorescence"%.%"OD"[730]^-1)
p.label.norm.fl.od <- bquote("Normalized fluorescence"%.%"OD"[730]^-1)
p.label.nm <- "Wavelength (nm)"
p.label.norm.abs <- "Normalized absorbance"
p.label.mu <- bquote(mu~("h"^-1))
