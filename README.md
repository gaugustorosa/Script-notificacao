<p>Esse script é projetado para notificar usuários do Active Directory sobre a expiração iminente de sua senha via e-mail. Ele pode ser configurado para ser executado automaticamente em intervalos regulares, garantindo que os usuários sejam notificados com antecedência suficiente para alterar suas senhas antes que expirem.</p>

<h2>Pré-requisitos</h2>
<ul>
	<li>Um ambiente Active Directory configurado</li>
	<li>Acesso administrativo ao servidor ou estação de trabalho onde o script será executado</li>
	<li>PowerShell 5.0 ou superior instalado na máquina onde o script será executado</li>
	<li>Conta de e-mail SMTP válida para enviar as notificações por e-mail</li>
</ul>

<h2>Instalação</h2>
<ol>
	<li>Baixe o arquivo do script <code>PasswordExpirationNotification.ps1</code>.</li>
	<li>Abra o PowerShell como administrador e execute o seguinte comando: <code>Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser</code>. Isso permitirá que o script seja executado em sua máquina.</li>
	<li>Edite o arquivo do script <code>PasswordExpirationNotification.ps1</code> com suas informações de configuração (veja a seção de configuração abaixo).</li>
	<li>Agende a execução do script para que seja executado automaticamente em intervalos regulares. Isso pode ser feito por meio do Agendador de Tarefas do Windows ou por outra ferramenta de agendamento de tarefas de sua preferência.</li>
</ol>

<h2>Configuração</h2>
<p>Antes de executar o script, você deve configurá-lo com suas informações específicas. As seguintes variáveis devem ser atualizadas no arquivo do script:</p>

<ul>
	<li><code>$daysBeforeExpiration</code>: O número de dias antes da expiração da senha que a notificação deve ser enviada. O padrão é 14 dias.</li>
	<li><code>$smtpServer</code>: O nome ou endereço IP do servidor SMTP que será usado para enviar as notificações por e-mail.</li>
	<li><code>$smtpPort</code>: A porta SMTP a ser usada para enviar as notificações por e-mail. O padrão é 587.</li>
	<li><code>$smtpUser</code>: A conta de e-mail SMTP que será usada para enviar as notificações por e-mail.</li>
	<li><code>$smtpPassword</code>: A senha da conta de e-mail SMTP que será usada para enviar as notificações por e-mail.</li>
	<li><code>$fromAddress</code>: O endereço de e-mail que aparecerá como remetente das notificações por e-mail.</li>
	<li><code>$subject</code>: O assunto que aparecerá nas notificações por e-mail.</li>
	<li><code>$body</code>: O corpo da mensagem que aparecerá
