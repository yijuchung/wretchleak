library("grDevices")

my.detach <- function (pkg) {
  pos = match(pkg, search())
  if (!is.na(pos)) detach(pos=pos)
}

list.exists <- function(list, el.name)
{
  return(sum(match(names(list), el.name),na.rm=T)>0)
}

# utility functions
g10="gray10"
g20="gray20"
g30="gray30"
g40="gray40"
g50="gray50"
g60="gray60"
g65="gray65"
g70="gray70"
g75="gray75"
g80="gray80"
g90="gray90"
gre=rgb(0,166/255,81/255)
blu=rgb(0,174/255,239/255)

lcol = rep(c(blu, 2, gre, 1, 4, 3),2) # line colors
lty = c(1, 2, 4, 3, 5, 1, 2, 4, 3, 5) # line types
pch = c(1,2,3,22,15,16,17,18)

bcol.sky = sort(colors()[grep("sky",colors())]);
bcol.red = sort(grep("red",colors()));
#bcol.double = c("grey60", "grey90");
#bcol.gender = c("grey60", "grey90");

bcol.gender = c("#aad3e7", "#ffe2d9");
bcol.double = c("#aad3e7", "#ffefd9");


# need to complete the gray color 

bcol.triple = c("#ffd7b8", "#b7d6eb", "#34cf7d");
bcol.line = c( "#b7d6eb", "#34cf7d", "#ffd7b8");
bcol.series = c(heat.colors(100), terrain.colors(100), topo.colors(100), cm.colors(100));
#"lightblue", "mistyrose", "lightcyan", "cornsilk"

boxplot.transform <- function (tr.v, cutp = tr.human.count) {
  r = list()
  r[1:cutp] = tr.v[1:cutp]
  r[(cutp+2):(tr.count+1)] = tr.v[(cutp+1):tr.count]
  r[cutp+1] = NA;

  nam = tr.names
  nam[1:cutp] = tr.names[1:cutp]
  nam[(cutp+2):(tr.count+1)] = tr.names[(cutp+1):tr.count]
  nam[cutp+1] = ""

  names(r) = nam

  invisible(r)
}

colors.show <- function() {
  plot(rep(10,16),col=1:16,pch=15,cex=5)
}

sr <- function(x) source(x)

x.index.old <- function(x, log=F, n=300) {

  if (length(x) < n) return (1:length(x))
  if (log) {
    x = x - min(x) + 0.1
    x = log10(x)
  }

  dig = 0
  index = integer()
  while (n > 0) {
    s <- which(!duplicated(round(x, dig)))
    s <- setdiff(s, index)
    if (!length(s)) break      
    if (length(s) > n) s = sample(s, n)

    index = union(index, s)
    n = n - length(s)
    dig = dig+1
  }

  unique(sort(c(index, 1, length(x))))
}

x.index <- function(x, n=300)
{
  if (len(x)<n) return (1:len(x))
  clu = kmeans(x,n,iter.max=100)
  which(!duplicated(clu$cluster))
}

xy.index <- function(x, y, n=300)
{
  stopifnot(len(x)==len(y))
  if (len(x)<n) return (1:len(x))
  mat = matrix(c(x,y),ncol=2)
  clu = kmeans(mat,n,iter.max=100)
  which(!duplicated(clu$cluster))
}
    
my.rug <- function(x, count=500) {
  x=sample(x, min(length(x), count))
  jx <- jitter(x[!is.na(x)])
  rug(jx, lwd=.5)
}

gmean <- function(x, na.rm = T) {
  x = x[!is.na(x)]
  if (is.vector(x) && length(x) > 0)
    exp(mean(log(x[x!=0])))
  else
    NA
}

psd.x <- function(f, f.thrd, v.thrd, f.max = NULL, n = 500) {
  if (!is.null(f.max)) f = f[f$f <= f.max,]
  x1=seq(1,length(f$f),ceiling(length(f$f)/n))
  x2=which(f$v>v.thrd)
  x2=x2[order(f$v[x2],decreasing=T)]
  for (i in 1:(length(x2)-1)) {
    if (is.na(x2[i])) next;
    d = abs(f$f[x2[(i+1):length(x2)]]-f$f[x2[i]])
    x2[(i+1):length(x2)][d < f.thrd]=NA
  }
  x2=x2[!is.na(x2)]

  unique(sort(c(x1, x2)))
}

cdf.anchor <- function(cdf, x, lty=2, col=4, all=F)
{
  if (!all) {
    segments(0, cdf(x), x, cdf(x), lty=lty, col=col)
    segments(x, cdf(x), x, 0, lty=lty, col=col)
  } else {
    abline(v = x, lty=lty, col=col)
    abline(h = cdf(x), lty=lty, col=col)
  }
}

km.index <- function(km, group=0, log=F)
{
  if (group == 0)
    index == 1:n
  else if (group == 1)
    index <- 1:km$strata[1]
  else {
    m <- sum(km$strata[1:(group-1)])
    index <- (m+1):(m+km$strata[group])
  }

  min(index) - 1 + x.index(km$time[index], log)
}

ewma <- function (x, lambda = 1)
{
  filter(lambda*x, filter=1-lambda, method="recursive", init=x[1])
}

ma <- function (x, k)
{
  filter(x, filter=rep(1,k), method="convolution") / k
}

md <- function(x) 
{
  mm = mean(x)
  sum(abs(x - mm))/length(x) 
}

len <- function(...) length(...)
cov <- function(x) {sd(x)/mean(x)}

unattr <- function(x) {attributes(x) <- NULL; x}

strstr <- function(pattern, s) {
  length(grep(pattern,s,fixed=T))>0
}

strstr.c <- function(s, pattern) {
  length(grep(pattern,s,fixed=T))>0
}


zero.based <- function(x) {x - min(x)}
density.norm <- function(x) {x$y = x$y / max(x$y); x}

x.mode <- function (x) 
{
  u = sort(unique(x))
  count = sapply(u, function(uu) sum(x==uu))
  u[which.max(count)]    
}

sorted = function(x) all(sort(x)==x)

int.to.str <- function(x) paste(x, sep="", collapse=",")
str.to.int <- function(x) as.integer(strsplit(x, ",")[[1]])
alpha.map = c("a","b","c","d","e","f","g","h","i","j","k","l")

# Usage: print(combination(4,2))
combination <- function(n, r) 
{
  res = list()
  
  a = 1:r
  count = 1
  while (T) {
    #cat(a, "\n")
    res[[count]] = a
    count = count + 1

    # generate next combination in lexicographical order
    i = r - 1;                   # start at last item        
    while (i >= 0 && a[i+1] == (n - r + i + 1))  # find next item to increment 
      i = i - 1

    if (i < 0) break;                          # all done
    a[i+1] = a[i+1] + 1                            # increment  

    # do next   
    if ((i+1)>(r-1)) next
    for (j in (i+1):(r-1))
      a[j+1] = a[i+1] + j - i
  }
  
  res
}


list.remove.null <- function (l) {
  if (!len(l)) return (l)
  i = 1
  while (i <= len(l)) {
    if (is.null(l[[i]])) l[[i]] = NULL else
    i = i+1
  }
  l
}

### for LaTeX table output

numeric.math <- function (s) {
  s = as.character(s)
  x = unlist(strsplit(s, " "))
  oo = options(warn=-1)
  for (i in 1:len(x)) {
    xi = x[i]
    is.percent = substr(xi, nchar(xi), nchar(xi)) == "%"
    if (is.percent) xi = substr(xi, 1, nchar(xi)-1)
    if (is.na(as.numeric(xi))) next
    
    is.float = strstr.c(xi, ".")
    xi = ifelse(is.float, xi, format(as.integer(xi),big.mark=","))
    xi = ifelse(is.percent, paste(xi, "%", sep=""), xi)
    x[i] = paste("$",xi,"$",sep="")
  }
  options(oo)
  paste(x, collapse=" ")
}


my.latex <- function(obj, ...) {
  if (!inherits(obj, "data.frame")) stop()
  
  for (i in 1:len(obj)) {
    for (j in 1:len(obj[[i]])) {
      obj[j,i] = numeric.math(obj[j,i])
    }
  }
  
  latex(obj, table.env=T, ctable=F, nomargins=F, vbar=T,
    
    na.blank=T, first.hline.double=F, multicol=T, where="t",  ...)
}

put.sep <- function() cat(" & ")
put.hline <- function() cat("\\hline\n")
put.newline <- function() cat("\\\\\\hline\n")
put.num <- function(x) cat("$", x, "$", sep="")
