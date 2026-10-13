# Серверы клиентов. Скопируйте файл в clients.psd1 (он не попадает в git) и заполните.
# Пароли здесь не хранятся: при необходимости deploy.ps1 запускается с -Credential (Get-Credential).
@{
  fm = @{
    Server    = '192.168.1.10'                         # имя или IP сервера (нужен WinRM)
    AppDir    = 'C:\Program Files\Apache Software Foundation\Tomcat 9.0\webapps\ROOT'
    Service   = 'Tomcat9'                              # имя службы: Get-Service *tomcat*
    Url       = 'http://localhost:8080/login.s'        # проверяется с самого сервера
    # BackupDir = 'D:\fm_deploy_backups'               # по умолчанию <Tomcat>\deploy_backups
    # Preserve  = @('WEB-INF\classes\db.properties')   # файлы, которые на сервере не перезаписываются
  }

  # Сервер без WinRM: архив копируется вручную, deploy.ps1 запускается на самом сервере
  # clinic2 = @{
  #   Local   = $true
  #   AppDir  = 'C:\Tomcat\webapps\ROOT'
  #   Service = 'Tomcat8'
  #   Url     = 'http://localhost:8080/login.s'
  # }
}
