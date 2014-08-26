bitmapfiles <- list.files(pattern="*.bitmap")
for(f in bitmapfiles){
pdf(paste(f,"pdf",sep="."));

      m <- as.matrix(read.table(f));
      image(m, axes = FALSE, col = grey(seq(0, 1, length = 2)));
dev.off();
}
