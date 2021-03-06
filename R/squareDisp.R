## squareDisp-methods
##
##
###############################################################################
###############################################################################

##------------------------------------------------------------------------------
## squareDisp

## calculate square displacement of a track/trajectory as a function of time/step
## data.frame has two column, x and y
## also calculate dx, dy bivariate

##' @export squareDisp
## such a basic function that has been used in msd and cdf, need to export
## add help page later TODO

## returns a list of length dt. i.e. when dt=2, it returns a list of 2 with two item, first corresponding to dt=1, second corresponding to dt=2. colnames are x,y, square.disp,dx,dy.

# it should be explicitly say that the dt is not at dt but from 1 to dt
# use to.dt or dt=1:1 or simply only calculate at dt, then use lapply(1:7, squareDisp)
# this way of confusing is because the intial msd caculation, that dt actually means 1:dt

# add this TODO, change it to specific dt or change its nomenclature. this will affect msd and displacementCDF, change accordingly.

# it is actally at dt

squareDisp=function(track,dt=1,resolution=0.107){

    # validity check, stop if dt greater than track length
    if (dt >(dim(track)[1]-1)){
        stop("\ntrack length:\t",dim(track)[1],"\ndt:\t\t",dt,
             "\nTime interval (dt) greater than track length-1\n")}

    # store dt-wise sub tracks into a list
    track.dt=list()
    for (i in 1:dt){

        # dt, time lags; the number of time interval used for measurement.
        # default every one step. i, indexing through dt

        # define start
        # divide track into dt-wise-subtracks, store them in the form of list
        # # at each specified dt, there are N-dt number of subtracks
        track.dt[[i]]=track[seq(from=i,to=dim(track)[1],by=dt),]

        # define lag compute square.disp in dt-wise-subtracks, stored them in
        # original data.frame. note this lag is a dplyr::lag, not base::lag,
        # which only works for time series

        x.disp=(track.dt[[i]]$x-dplyr::lag(track.dt[[i]]$x,n=1))*resolution
        y.disp=(track.dt[[i]]$y-dplyr::lag(track.dt[[i]]$y,n=1))*resolution

        # below is an alternative definition
        # view displacement as displacement to initial position, how far it has
        # moved, rather than to previous position

        # x.disp=(track.dt[[i]]$x-track.dt[[i]]$x[1])*resolution
        # y.disp=(track.dt[[i]]$y-track.dt[[i]]$y[1])*resolution

        square.disp=x.disp^2+y.disp^2
        index=rownames(track.dt[[i]])

        # track.dt[[i]]=dplyr::mutate(track.dt[[i]],index,square.disp,
        #                             dx=x.disp,dy=y.disp)
        # for performance purpose
        track.dt[[i]]=cbind(track.dt[[i]],index,square.disp,dx=x.disp,dy=y.disp)

    }

    return(track.dt)

}


# compile track wise computations to bytecode for performance
# compiler::enableJIT(3)
# squareDisp=compiler::cmpfun(squareDisp,options=list(optimize=3))
# compiler::enableJIT(0)

# no difference when enableJIT
#
# #------------------------------------------------------------------------------
# # TODO: calculate displacement variance
#
# variance for each trajectory
# move small steps, or varies hugely
#
# distribution of displacement, tells how centralized or spread the trajectory is, is a parameter to measure trajectory
# calculate square displacement for all tracks



##------------------------------------------------------------------------------
## squareDispCpp

## calculate square displacement of a track/trajectory as a function of time/step
## data.frame has two column, x and y
## also calculate dx, dy bivariate

##' @export squareDispCpp

##' @importFrom Rcpp sourceCpp

squareDispCpp = function(track, dt = 1, resolution = 0.107){
    #convert given track to matrix type
    track.out = data.matrix(track);

    #Compile source C++ file
    file=system.file("cpp",package="smt", "squareDispRcpp.cpp");
    sourceCpp(file);

    #run squareDispRcpp.cpp
    track.dt = squareDispRcpp(track.out, dt, resolution);
    return (track.dt);
}

