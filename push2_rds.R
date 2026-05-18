# ------------------------------------------------------------
# Script definitivo para enviar apenas arquivos .rds novos/modificados
# Repositório: https://github.com/Marcosazreis/base-cvm
# ------------------------------------------------------------

setwd("C:/Users/gmarc/Documents/base-cvm")

# 0. Garantir identidade local (evita erros no Windows)
system('git config user.name "Marcosazreis"')
system('git config user.email "gmarcos.reis@gmail.com"')

# 1. Verificar se o Git está configurado
git_name  <- system("git config user.name", intern = TRUE)
git_email <- system("git config user.email", intern = TRUE)

if (git_name == "" || git_email == "") {
  stop("❌ Git sem identidade configurada.")
}

# 2. Pasta onde estão os arquivos .rds
pasta_origem <- "C:/Users/gmarc/OneDrive/Documentos/2026/Investimento/Dados"

# 3. Listar arquivos .rds
arquivos_rds <- list.files(
  path = pasta_origem,
  pattern = "\\.rds$",
  full.names = TRUE
)

if (length(arquivos_rds) == 0) {
  stop("Nenhum arquivo .rds encontrado na pasta de origem.")
}

cat("Arquivos encontrados:\n")
print(arquivos_rds)

# 4. Copiar apenas arquivos novos ou modificados
arquivos_copiados <- c()

for (arq in arquivos_rds) {
  destino <- file.path(".", basename(arq))
  
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

# 5. PULL COM REBASE (evita conflitos e rejeições)
cat("\n🔄 Atualizando repositório (git pull --rebase)...\n")
pull_status <- system("git pull origin main --rebase")

if (pull_status != 0) {
  stop("❌ Erro no pull --rebase. Resolva conflitos antes de continuar.")
}

# 6. Adicionar apenas arquivos modificados
system(paste("git add", paste(arquivos_copiados, collapse = " ")))

# 7. Commit
mensagem_commit <- paste(
  "Atualiza arquivos RDS:",
  paste(arquivos_copiados, collapse = ", ")
)

commit_status <- system(paste('git commit -m "', mensagem_commit, '"'))

if (commit_status != 0) {
  stop("❌ Erro ao criar commit.")
}

# 8. Push
cat("\n🚀 Enviando para o GitHub...\n")
push_status <- system("git push origin main")

if (push_status != 0) {
  stop("❌ Erro ao enviar para o GitHub.")
}

cat("\n✅ Upload concluído com sucesso!\n")