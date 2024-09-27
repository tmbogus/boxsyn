# Load required libraries
library(FactoMineR)  # For performing Multiple Correspondence Analysis
library(ggplot2)     # For data visualization
library(missMDA)     # For handling missing data

# File paths for input and output
input_file <- "chromos_screen_hittbl.clean.NA.tsv"
output_dir <- "output/"
dir.create(output_dir, showWarnings = FALSE)

# Read and preprocess input data
chromosome_data <- read.table(input_file, colClasses = c(NULL, "factor", "factor", "factor", "factor"), header = TRUE)
chromosomes <- chromosome_data[2:5]

# Get the number of categories for each variable
category_counts <- apply(chromosomes, 2, function(x) nlevels(as.factor(x)))
print(category_counts)

# Impute missing data using MCA's built-in method
imputed_data <- imputeMCA(chromosomes, ncp = 4)$tab.disj

# Perform Multiple Correspondence Analysis (MCA)
mca_results <- MCA(chromosomes, tab.disj = imputed_data, graph = TRUE)

# Perform hierarchical clustering on the MCA results
HCPC(mca_results, kk = 1000, nb.clust = -1)

# Create data frames for plotting
mca_variables_df <- data.frame(mca_results$var$coord, 
                               Variable = rep(names(category_counts), category_counts))
mca_observations_df <- data.frame(mca_results$ind$coord)

# Write MCA results to output files
write.table(mca_variables_df, file = paste0(output_dir, "mca4_vars.txt"), 
            sep = "\t", row.names = TRUE, col.names = TRUE)
write.table(mca_observations_df, file = paste0(output_dir, "mca4_obs.txt"), 
            sep = "\t", row.names = TRUE, col.names = TRUE)

# Function to create scatter plots of MCA dimensions
plot_mca_results <- function(df, dim_x, dim_y, output_file, var_df) {
  pdf(output_file)
  ggplot(data = df, aes_string(x = dim_x, y = dim_y)) +
    geom_hline(yintercept = 0, colour = "gray70") +
    geom_vline(xintercept = 0, colour = "gray70") +
    geom_point(colour = "gray50", alpha = 0.7) +
    geom_density2d(colour = "gray80") +
    geom_text(data = var_df, aes_string(x = dim_x, y = dim_y, 
                                        label = "rownames(var_df)", colour = "Variable")) +
    ggtitle(paste("MCA plot of dimensions", dim_x, "and", dim_y)) +
    scale_colour_discrete(name = "Variable")
  dev.off()
}

# Generate all pairwise combinations of dimensions 1 through 4
dimensions <- 1:4
dimension_pairs <- combn(dimensions, 2, simplify = FALSE)

# Generate plots for all pairwise combinations of dimensions
for (pair in dimension_pairs) {
  dim_x <- paste0("Dim.", pair[1])
  dim_y <- paste0("Dim.", pair[2])
  plot_mca_results(mca_observations_df, dim_x, dim_y, paste0(output_dir, "mca4_", dim_x, "_", dim_y, ".pdf"), mca_variables_df)
}

# Plot ellipses
pdf(paste0(output_dir, "mcad4_ellipses.pdf"))
plotellipses(mca_results, cex = 0.005, magnify = 200)
dev.off()

# Write the results of catdes for each species into separate files
species <- c("Sb", "Zm", "Os", "Bd")
for (i in seq_along(species)) {
  res_catdes <- catdes(chromosomes, i)
  write.infile(res_catdes, file = paste0(output_dir, "catdes_", species[i], ".txt"), sep = "\t")
}

# Write dimdesc results
dimdesc_res <- dimdesc(mca_results, axes = 1:5)
write.infile(dimdesc_res, file = paste0(output_dir, "dimdesc.txt"), sep = "\t")

# Write eigenvalues to file
write.infile(mca_results$eig, file = paste0(output_dir, "eigenvalues.txt"), sep = "\t")
