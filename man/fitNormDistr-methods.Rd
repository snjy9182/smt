% Generated by roxygen2 (4.1.1): do not edit by hand
% Please edit documentation in R/fitNormDistr.R
\docType{methods}
\name{fitNormDistr}
\alias{.fitNormDistr}
\alias{fitNormDistr}
\title{fitNormDistr}
\usage{
fitNormDistr(dcoef,components=NULL,log.transform=F,binwidth=NULL,
             combine.plot=F,output=F,seed=NULL)
}
\arguments{
\item{dcoef}{diffusion coefficient calculated from Dcoef().}

\item{components}{parameter specifying the number of components to fit. If NULL (default), a components analysis is done to determine the most likely components and this number is then used for subsequent analysis.}

\item{log.transform}{logical indicate if log10 transformation is needed, default F.}

\item{binwidth}{binwidth for the combined plot. If NULL (default), will automatic assign binwidth.}

\item{combine.plot}{Logical indicating if all the plot should be combined into one, with same scale (/same axises breaks), same color theme, and same bin size for comparison.}

\item{output}{Logical indicaring if output file should be generated.}

\item{seed}{Seed for random number generator. This makes each run easily repeatable. Seed will be automatically assigned if no seed is specified (default). The seed information is stored as an attribute of the returned object. The seed can also be output to a txt file when output=T.}
}
\value{
\describe{
\item{proportions}{The proportions of mixing components.}
\item{mean}{The Means of the components.}
\item{sd}{The Standard Deviations (SD) of components if not log transformed; if log transformed, it is then interpreted as Coefficient of Variation (CV).}
\item{loglik}{The log likelihood, useful for compare different fitting result, the bigger the better fit.}
}
}
\description{
fit normal distribution to diffusion coefficient caclulated by Dcoef method.
}
\details{
components analysis uses the likelihood ratio test (LRT) to assess the number of mixture components.
}
\examples{
# compare folders
folder1=system.file("extdata","SWR1",package="smt")
folder2=system.file("extdata","HTZ1",package="smt")
trackll=compareFolder(c(folder1,folder2))
MSD=msd(trackll=trackll)
dcoef=Dcoef(MSD,dt=6,plot=T,output=F)
# fit dcoef
a=fitNormDistr(dcoef,components=NULL,log.transform=F,combine.plot=F,output=F)
# to repeat a
b=fitNormDistr(dcoef,components=NULL,log.transform=F,combine.plot=F,output=F,seed=attr(a,"seed"))
# if a and b are the same
mapply(identical,a[[1]],b[[1]])
}

