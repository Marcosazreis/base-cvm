# ------------------------------------------------------------
# Script aprimorado para enviar apenas arquivos .rds novos ou modificados
# Repositório: https://github.com/Marcosazreis/base-cvm
# ------------------------------------------------------------

# 1. Caminho onde os arquivos .rds estão salvos (OneDrive)
pasta_origem <- "C:/Users/gmarc/OneDrive/Documentos/2026/Investimento/Dados"

# 2. Listar todos os arquivos .rds da pasta
arquivos_rds <- list.files(
  path = pasta_origem,
  pattern = "\\.rds$",
  full.names = TRUE
)

if (length(arquivos_rds) == 0) {
  stop("Nenhum arquivo .rds encontrado na pasta de origem.")
}

cat("Arquivos encontrados na origem:\n")
print(arquivos_rds)

# 3. Copiar apenas arquivos novos ou modificados
arquivos_copiados <- c()

for (arq in arquivos_rds) {
  
  destino <- file.path(".", basename(arq))
  
  # Se o arquivo não existe no repo OU foi modificado, copie
  if (!file.exists(destino) ||
      file.info(arq)$mtime > file.info(destino)$mtime) {
    
    file.copy(arq, destino, overwrite = TRUE)
    arquivos_copiados <- c(arquivos_copiados, basename(arq))
    cat("Copiado/atualizado:", basename(arq), "\n")
  }
}

if (length(arquivos_copiados) == 0) {
  cat("\nNenhum arquivo novo ou modificado. Nada a enviar.\n")
  quit(save = "no")
}

# 4. Adicionar apenas os arquivos copiados ao Git
system(paste("git add", paste(arquivos_copiados, collapse = " ")))

# 5. Commit único
mensagem_commit <- paste(
  "Atualiza arquivos RDS:",
  paste(arquivos_copiados, collapse = ", ")
)

system(paste('git commit -m "', mensagem_commit, '"'))

# 6. Push para o GitHub
system("git push origin main")

cat("\nUpload concluído com sucesso!\n")