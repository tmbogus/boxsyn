require(FactoMineR)
require(ggplot2)
chromo<-read.table("chromos_screen_hittbl.clean.tsv",colClasses=c(NULL,"factor","factor","factor","factor"), header=TRUE);
chromos=chromo[2:5];
cats = apply(chromos, 2, function(x) nlevels(as.factor(x)));
cats;

mca4=MCA(chromos, graph=FALSE);

mca4_vars_df = data.frame(mca4$var$coord, Variable = rep(names(cats), cats));
mca4_obs_df = data.frame(mca4$ind$coord);

pdf("mca4.vars.pdf");
plot.MCA(mca4, invisible=c("ind","quali.sup"), cex=0.7);
dev.off();

pdf("mca4.1.pdf");
ggplot(data = mca4_obs_df, aes(x = Dim.1, y = Dim.2)) +
  geom_hline(yintercept = 0, colour = "gray70") +
  geom_vline(xintercept = 0, colour = "gray70") +
  geom_point(colour = "gray50", alpha = 0.7) +
  geom_density2d(colour = "gray80") +
  geom_text(data = mca4_vars_df, 
            aes(x = Dim.1, y = Dim.2, 
                label = rownames(mca4_vars_df), colour = Variable)) +
  ggtitle("mca4 plot of variables") +
scale_colour_discrete(name = "Variable");
dev.off();

pdf("mca4.2.pdf");
ggplot(data = mca4_obs_df, aes(x = Dim.1, y = Dim.3)) +
  geom_hline(yintercept = 0, colour = "gray70") +
  geom_vline(xintercept = 0, colour = "gray70") +
  geom_point(colour = "gray50", alpha = 0.7) +
  geom_density2d(colour = "gray80") +
  geom_text(data = mca4_vars_df, 
            aes(x = Dim.1, y = Dim.3, 
                label = rownames(mca4_vars_df), colour = Variable)) +
  ggtitle("mca4 plot of variables") +
scale_colour_discrete(name = "Variable");
dev.off();

pdf("mca4.3.pdf");
ggplot(data = mca4_obs_df, aes(x = Dim.3, y = Dim.1)) +
  geom_hline(yintercept = 0, colour = "gray70") +
  geom_vline(xintercept = 0, colour = "gray70") +
  geom_point(colour = "gray50", alpha = 0.7) +
  geom_density2d(colour = "gray80") +
  geom_text(data = mca4_vars_df, 
            aes(x = Dim.3, y = Dim.1, 
                label = rownames(mca4_vars_df), colour = Variable)) +
  ggtitle("mca4 plot of variables") +
scale_colour_discrete(name = "Variable");
dev.off();

pdf("mca4.4.pdf");
ggplot(data = mca4_obs_df, aes(x = Dim.3, y = Dim.2)) +
  geom_hline(yintercept = 0, colour = "gray70") +
  geom_vline(xintercept = 0, colour = "gray70") +
  geom_point(colour = "gray50", alpha = 0.7) +
  geom_density2d(colour = "gray80") +
  geom_text(data = mca4_vars_df, 
            aes(x = Dim.3, y = Dim.2, 
                label = rownames(mca4_vars_df), colour = Variable)) +
  ggtitle("mca4 plot of variables") +
scale_colour_discrete(name = "Variable");
dev.off();

pdf("mca4.5.pdf");
ggplot(data = mca4_obs_df, aes(x = Dim.2, y = Dim.4)) +
  geom_hline(yintercept = 0, colour = "gray70") +
  geom_vline(xintercept = 0, colour = "gray70") +
  geom_point(colour = "gray50", alpha = 0.7) +
  geom_density2d(colour = "gray80") +
  geom_text(data = mca4_vars_df, 
            aes(x = Dim.2, y = Dim.4, 
                label = rownames(mca4_vars_df), colour = Variable)) +
  ggtitle("mca4 plot of variables") +
scale_colour_discrete(name = "Variable");
dev.off();

pdf("mca4.6.pdf");
ggplot(data = mca4_obs_df, aes(x = Dim.3, y = Dim.4)) +
  geom_hline(yintercept = 0, colour = "gray70") +
  geom_vline(xintercept = 0, colour = "gray70") +
  geom_point(colour = "gray50", alpha = 0.7) +
  geom_density2d(colour = "gray80") +
  geom_text(data = mca4_vars_df, 
            aes(x = Dim.3, y = Dim.4, 
                label = rownames(mca4_vars_df), colour = Variable)) +
  ggtitle("mca4 plot of variables") +
scale_colour_discrete(name = "Variable");
dev.off();

pdf("mca4.ellipses.pdf");
plotellipses(mca4,cex=0.005,magnify=200)
dev.off()

res=catdes(chromos,1);
write.infile(res, file="catdesSb.txt", sep="\t");

res=catdes(chromos,2);
write.infile(res, file="catdesZm.txt", sep="\t");

res=catdes(chromos,3);
write.infile(res, file="catdesOs.txt", sep="\t");

res=catdes(chromos,4);
write.infile(res, file="catdesBd.txt", sep="\t");

res=dimdesc(mca4,axes=1:5);
write.infile(res, file="dimdesc.txt", sep="\t");

write.infile(mca4$eig, file="eigenvalues.txt", sep="\t");
