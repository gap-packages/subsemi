bitmapfiles <- list.files(pattern="*[.]bitmap$")
for(f in bitmapfiles){
  m <- as.matrix(read.table(f));
  pdf(paste(f,"png",sep="."));
  image(m, axes = FALSE, col = grey(seq(0, 1, length = 2)));
  dev.off();
}
