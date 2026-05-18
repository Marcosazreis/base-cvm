# ------------------------------------------------------------
# Envia arquivos .rds novos/modificados para o GitHub
# Repositório: https://github.com/Marcosazreis/base-cvm
# ------------------------------------------------------------

repo_path <- "C:/Users/gmarc/Documents/base-cvm"
setwd(repo_path)

# 0. Garantir identidade local
system('git config user.name "Marcosazreis"')
system('git config user.email "gmarcos.reis@gmail.com"')

# 1. Verificar se o Git está configurado
git_name  <- system("git config user.name", intern = TRUE)
git_email <- system("git config user.email", intern = TRUE)

if (length(git_name) == 0 || git_name == "" ||
    length(git_email) == 0 || git_email == "") {
  stop("Git sem identidade configurada.")
}

# 2. Fazer pull primeiro, antes de qualquer mudança staged
# --autostash guarda temporariamente arquivos locais, faz o pull e restaura
cat("Atualizando repositório (git pull --rebase --autostash)...\n")
pull_status <- system("git pull origin main --rebase --autostash")

if (pull_status != 0) {
  stop("Erro no pull --rebase. Verifique conexão ou conflitos no repositório.")
}

# 3. Verificar se há mudanças (arquivos novos ou modificados)
status_output <- system("git status --porcelain", intern = TRUE)

if (length(status_output) == 0) {
  cat("\nNenhum arquivo novo ou modificado. Nada a enviar.\n")
  quit(save = "no")
}

n_arquivos <- length(status_output)
cat(sprintf("\n%d arquivo(s) com mudanças detectadas pelo Git.\n", n_arquivos))

# 4. Adicionar tudo
system("git add -A")

# 5. Commit
mensagem_commit <- paste0("Atualiza dados CVM: ", n_arquivos, " arquivo(s)")
commit_status <- system(paste0('git commit -m "', mensagem_commit, '"'))

if (commit_status != 0) {
  stop("Erro ao criar commit.")
}

# 6. Push
cat("\nEnviando para o GitHub...\n")
push_status <- system("git push origin main")

if (push_status != 0) {
  stop("Erro ao enviar para o GitHub.")
}

cat("\nUpload concluído com sucesso!\n")
