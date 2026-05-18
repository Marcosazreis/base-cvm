# ------------------------------------------------------------
# Script aprimorado para enviar apenas arquivos .rds novos ou modificados
# Repositório: https://github.com/Marcosazreis/base-cvm
# ------------------------------------------------------------

setwd("C:/Users/gmarc/Documents/base-cvm")

system('git config user.name "Marcosazreis"')
system('git config user.email "gmarcos.reis@gmail.com"')

system("git config user.name")
system("git config user.email")

# 0. Verificar se o Git tem nome e email configurados
git_name  <- system("git config user.name", intern = TRUE)
git_email <- system("git config user.email", intern = TRUE)

if (git_name == "" || git_email == "") {
  stop("❌ Git sem identidade configurada. Rode no terminal:\n\n",
       'git config --global user.name "Seu Nome"\n',
       'git config --global user.email "seu_email@exemplo.com"\n')
}


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

# 4. git pull antes de tudo
cat("\n🔄 Executando git pull...\n")
pull_status <- system("git pull origin main")

if (pull_status != 0) {
  stop("❌ Erro ao executar git pull. Resolva conflitos antes de continuar.")
}

# 5. Adicionar apenas os arquivos copiados ao Git
system(paste("git add", paste(arquivos_copiados, collapse = " ")))

# 6. Commit único
mensagem_commit <- paste(
  "Atualiza arquivos RDS:",
  paste(arquivos_copiados, collapse = ", ")
)

commit_status <- system(paste('git commit -m "', mensagem_commit, '"'))

if (commit_status != 0) {
  stop("❌ Erro ao criar commit. Verifique o estado do repositório.")
}

# 7. Push para o GitHub
cat("\n🚀 Enviando para o GitHub...\n")

system("git pull origin main --rebase")

push_status <- system("git push origin main")


if (push_status != 0) {
  stop("❌ Erro ao enviar para o GitHub. Verifique o repositório remoto.")
}

cat("\n✅ Upload concluído com sucesso!\n")


## Ajustes iniciais

system("git --version")

## Em novo terminal
# git config --global user.name "Marcos Reis"
# git config --global user.email "seu_email_do_github@example.com"

system("git config user.name")
system("git config user.email")

system("git status")
