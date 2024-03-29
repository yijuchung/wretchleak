my.barplot <- function (height, width = 1, space = NULL, names.arg = NULL, 
    legend.text = NULL, beside = FALSE, horiz = FALSE, density = NULL, 
    angle = 45, col = NULL, border = par("fg"), main = NULL, 
    sub = NULL, xlab = NULL, ylab = NULL, xlim = NULL, ylim = NULL, 
    xpd = TRUE, axes = TRUE, axisnames = TRUE, cex.axis = par("cex.axis"), 
    cex.names = par("cex.axis"), inside = TRUE, plot = TRUE, 
    axis.lty = 0, offset = 0, legend.x.adj = 1, legend.x.pos = NULL, ...) 
{
    if (!missing(inside)) 
        .NotYetUsed("inside", error = FALSE)
    if (missing(space)) 
        space <- if (is.matrix(height) && beside) 
            c(0, 1)
        else 0.2
    space <- space * mean(width)
    if (plot && axisnames && missing(names.arg)) 
        names.arg <- if (is.matrix(height)) 
            colnames(height)
        else names(height)
    if (is.vector(height) || (is.array(height) && (length(dim(height)) == 
        1))) {
        height <- cbind(height)
        beside <- TRUE
        if (is.null(col)) 
            col <- "grey"
    }
    else if (is.matrix(height)) {
        if (is.null(col)) 
            col <- grey.colors(nrow(height))
    }
    else stop("'height' must be a vector or a matrix")
    if (is.logical(legend.text)) 
        legend.text <- if (legend.text && is.matrix(height)) 
            rownames(height)
    NR <- nrow(height)
    NC <- ncol(height)
    if (beside) {
        if (length(space) == 2) 
            space <- rep.int(c(space[2], rep.int(space[1], NR - 
                1)), NC)
        width <- rep(width, length.out = NR)
    }
    else {
        width <- rep(width, length.out = NC)
        height <- rbind(0, apply(height, 2, cumsum))
    }
    offset <- rep(as.vector(offset), length.out = length(width))
    delta <- width/2
    w.r <- cumsum(space + width)
    w.m <- w.r - delta
    w.l <- w.m - delta
    if (horiz) {
        if (missing(xlim)) 
            xlim <- range(-0.01 * height + offset, height + offset, 
                na.rm = TRUE)
        if (missing(ylim)) 
            ylim <- c(min(w.l), max(w.r))
    }
    else {
        if (missing(xlim)) 
            xlim <- c(min(w.l), max(w.r))
        if (missing(ylim)) 
            ylim <- range(-0.01 * height + offset, height + offset, 
                na.rm = TRUE)
    }
    if (beside) 
        w.m <- matrix(w.m, nc = NC)
    if (plot) {
        opar <- if (horiz) 
            par(xaxs = "i", xpd = xpd)
        else par(yaxs = "i", xpd = xpd)
        on.exit(par(opar))
        plot.new()
        plot.window(xlim, ylim, log = "", ...)
        xyrect <- function(x1, y1, x2, y2, horizontal = TRUE, 
            ...) {
            if (horizontal) 
                rect(x1, y1, x2, y2, ...)
            else rect(y1, x1, y2, x2, ...)
        }
        if (beside) 
            xyrect(0 + offset, w.l, c(height) + offset, w.r, 
                horizontal = horiz, angle = angle, density = density, 
                col = col, border = border)
        else {
            for (i in 1:NC) {
                xyrect(height[1:NR, i] + offset[i], w.l[i], height[-1, 
                  i] + offset[i], w.r[i], horizontal = horiz, 
                  angle = angle, density = density, col = col, 
                  border = border)
            }
        }
        if (axisnames && !is.null(names.arg)) {
            at.l <- if (length(names.arg) != length(w.m)) {
                if (length(names.arg) == NC) 
                  colMeans(w.m)
                else stop("incorrect number of names")
            }
            else w.m
            axis(if (horiz) 
                2
            else 1, at = at.l, labels = names.arg, lty = axis.lty, 
                cex.axis = cex.names, ...)
        }
        if (!is.null(legend.text)) {
            legend.col <- rep(col, length.out = length(legend.text))
            if ((horiz & beside) || (!horiz & !beside)) {
                legend.text <- rev(legend.text)
                legend.col <- rev(legend.col)
                density <- rev(density)
                angle <- rev(angle)
            }
            xy <- par("usr")
            legend(ifelse(is.null(legend.x.pos), 
              ifelse(legend.x.adj == 0, xy[1] + xinch(0.2), xy[2] - xinch(0.1)),
                legend.x.pos), 
                xy[4] - yinch(0.1), legend = legend.text, 
                angle = angle, density = density, fill = legend.col, 
                xjust = legend.x.adj, yjust = 1)
        }
        title(main = main, sub = sub, xlab = xlab, ylab = ylab, 
            ...)
        if (axes) 
            axis(if (horiz) 
                1
            else 2, cex.axis = cex.axis, ...)
        invisible(w.m)
    }
    else w.m
}
