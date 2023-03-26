Import-Module ActiveDirectory
 
$Today = Get-Date
$warnDays = 7 # Dias antes da senha expirar para enviar a notificação.
 
# Configuração do e-mail.
$EmailFrom = "<e-mail>"
$SMTPServer = "<smtp-server>"
$SMTPClient = New-Object Net.Mail.SmtpClient($SmtpServer, 587) 
$SMTPClient.EnableSsl = $true
$SMTPClient.Credentials = New-Object System.Net.NetworkCredential("<e-mail>", "<senha do e-mail>"); 
 
# Listar todos os usuários ativos do Active Directory que a senha pode expirar
$ADUsers = Get-ADUser -Filter {Enabled -eq $true  -and PasswordNeverExpires -eq $false } -Properties 'msDS-UserPasswordExpiryTimeComputed', 'mail'
$AlreadyExpiredList = ""
 
# Para cada usuário
$Results = foreach( $User in $ADUsers ){
    # Pega a data de expiração e coloca no formato correto
    $ExpireDate = [datetime]::FromFileTime( $User.'msDS-UserPasswordExpiryTimeComputed' )
    $ExpireDate_String = $ExpireDate.ToString("dd/MM/yyyy HH:mm tt") # Padrão PT/BR
 
    # Calcula os dias restantes
    $daysRmmaining  = New-TimeSpan -Start $Today -End $ExpireDate
    $daysRmmaining = $daysRmmaining.Days
 
    $usersName = $User.Name
 
    # Verifica todos os usuários do AD que estão dentro do range de 7 dias em que a senha está para expirar.
    if ($daysRmmaining -le $warnDays -And $daysRmmaining -ge 0)
    {
        # Gera o assunto do e-mail com os dias restantes.
        if ($daysRmmaining -eq 0)
        {
            $emailSubject = "Sua senha de usuário expira hoje."
        } else {
            $emailSubject = "Sua senha de usuário irá expirar em $daysRmmaining dias"
        }
 
        # Pega o e-mail dos usuários
        if($null -eq $user.mail)
        {
            # O usuário não tem um e-mail registrado, alerte o TI.
            $sendTo = "<e-mail do TI>"
            $emailBody = "A senha do usuário $usersName expirou $ExpireDate_String. Mas não conseguimos notificá-lo, pois ele não tem e-mail registrado."
        } else {
            # Caso o usuário tenha um e-mail:
            $sendTo = $user.mail

            $html = $true


 	    # Corpo do e-mail.
            $emailBody = @"

            <table style="border-spacing: 0px; border-collapse: collapse; width: 100%;" border="0" width="100%" cellspacing="0"
            cellpadding="0">
         <tbody>
         <tr>
             <td class="x_outer"
                 style="font-family: Arial, sans-serif; min-width: 600px; border-collapse: collapse; background-color: #ebeff2; width: 100%;"
                 valign="top">
                 <table id="x_boxing" class="x_m_boxing"
                        style="border-spacing: 0; border-collapse: collapse; margin: 0 auto 0 auto;" border="0" width="640"
                        cellspacing="0" cellpadding="0" align="center">
                     <tbody>
                     <tr>
                         <td id="x_template-wrapper" class="x_mktoContainer x_boxedbackground"
                             style="word-break: break-word; font-family: Arial,sans-serif; border-collapse: collapse;">
                             <p></p>
                             <table id="x_hero" class="x_mktoModule x_m_hero"
                                    style="border-spacing: 0; border-collapse: collapse;" border="0" width="100%"
                                    cellspacing="0" cellpadding="0">
                                 <tbody>
                                 <tr>
                                     <td class="x_background" valign="top" bgcolor="#1B2F62" width="640" height="5px"
                                         data-imagetype="External">
                                         <center>
                                             <table class="x_table600"
                                                    style="border-spacing: 0; border-collapse: collapse; margin: 0 auto 0 auto;" 
                                                    border="0" width="580" cellspacing="0" cellpadding="0" align="center">
                                                 <tbody>
                                                 <tr>
                                                     <td class="x_primary-font x_subtitle"
                                                         style="word-break: break-word; font-family: Arial,sans-serif; text-align: left; color: black; font-weight: bold; font-size: 17px; border-collapse: collapse; padding-top: 1px;"></td>
                                                 </tr>
                                                 <tr>
                                                     <td class="x_primary-font x_title"
                                                         style="word-break: break-word; font-family: Arial,sans-serif; font-size: 30px; line-height: 25px; color: #32ad84; text-align: left; border-collapse: collapse; padding-bottom: 1px; padding-top: 10px;">
                                                         <div id="x_title" class="x_mktoText">
                                                             <div style="text-align: center;">
                                                                 <span style="color: #ffffff; font-size: 24px;"><span
                                                                         style="color: #02742E; font-size: 24px;"> <img
                                                                         src="https://cdn-c1.vivaintra.com/vivaintra-s3-tamoios/public/uploads/tamoios/logo/phpRzj72R_5ddbe3fd03af5.png"
                                                                         class="img-responsive" alt="Tamoios"></span></span>
                                                                 <div style="text-align: center;"><span
                                                                         style="font-size: 20px;"> <span
                                                                         style="color: #FEBD00;"><br> Segurança da Informação</span> </span>
                                                                 </div>
                                                             </div>
                                                         </div>
                                                     </td>
                                                 </tr>
                                                 <tr>
                                                     <td class="x_primary-font x_subtitle"
                                                         style="word-break: break-word; font-family: Arial,sans-serif; text-align: left; color: black; font-weight: bold; font-size: 17px; border-collapse: collapse; padding-top: 20px;"></td>
                                                 </tr>
                                                 </tbody>
                                             </table>
                                         </center>
                                     </td>
                                 </tr>
                                 </tbody>
                             </table>
                             <table id="x_free-text" class="x_mktoModule x_m_free-text"
                                    style="border-spacing: 0; border-collapse: collapse;" border="0" width="100%"
                                    cellspacing="0" cellpadding="0" align="center">
                                 <tbody>
                                 <tr>
                                     <td style="word-break: break-word; font-family: Arial,sans-serif; border-collapse: collapse; background-color: #ffffff;"
                                         valign="top" bgcolor="#FFFFFF">
                                         <center>
                                             <table class="x_table600"
                                                    style="border-spacing: 0; border-collapse: collapse; margin: 0 auto 0 auto;"
                                                    border="0" width="580" cellspacing="0" cellpadding="0" align="center">
                                                 <tbody>
                                                 <tr>
                                                     <td style="word-break: break-word; font-family: Arial,sans-serif; border-collapse: collapse; line-height: 25px; font-size: 25px;"
                                                         height="25px"></td>
                                                 </tr>
                                                 <tr>
                                                     <td class="x_primary-font x_text"
                                                         style="word-break: break-word; font-family: Arial,sans-serif; font-size: 14px; color: #333333; line-height: 170%; border-collapse: collapse;">
                                                         <div id="x_text4" class="x_mktoText">
                                                         <br></br>
                                                             <p>$usersName,</br></br>
                                                                 <b>Sua senha de usuário da rede expira em: $ExpireDate_String</b> </br></br>
     
                                                                 É importante alterar a sua senha para que não ocorra nenhum
                                                                 tipo de problema.</br></br>
     
                                                                 <b>Como resetar minha senha?</b></br>
                                                                 
                                                                 <b>1.</b> Se você não está conectado em nenhuma rede da
                                                                 empresa, conecte-se à VPN.</br>
                                                                 <b>2.</b> Pressione as teclas: CTRL + ALT + DELETE e
                                                                 selecione 'Alterar uma senha'.</br>
                                                                 <b>3.</b> Entre com sua senha atual, e então crie uma nova
                                                                 senha que corresponda com os requisitos minímos da política
                                                                 de senha.</br>
                                                                 <b>4.</b> Após alterar a senha, pressione novamente as
                                                                 teclas: CTRL + ALT + DELETE e clique em 'Bloquear'.</br>
                                                                 <b>5.</b> Entre com a sua nova senha de usuário.</br></br>
     
                                                                 Obrigado pela cooperação.</br></br>
     
                                                                 TI ADM</br>
                                                             </p>
                                                 <tr>
                                                     <td style="word-break: break-word; font-family: Arial,sans-serif; border-collapse: collapse;">
                                                         <center>
                                                             <table class="x_table1-3"
                                                                    style="border-spacing: 0px; border-collapse: collapse; height: 70px;"
                                                                    border="0" width="0" cellspacing="0" cellpadding="0"
                                                                    align="center">
                                                                 <tbody align="center">
                                                                 <tr style="height: 16px;">
                                                                 <tr>
                                                                     <td colspan="16"
                                                                         style="width: 400px; height: 20px; font-size: 15px; vertical-align: top;">
                                                                         <a style="color: #333c42; text-decoration: none;"
                                                                            href="https://concessionariatamoios.com.br/"><img
                                                                                 src="https://img.icons8.com/ios-glyphs/512/internet--v1.png"
                                                                                 width="20" height="20" title="Site"> </a><a
                                                                             href="https://www.linkedin.com/company/concessionária-tamoios/mycompany/"><img
                                                                             src="https://img.icons8.com/material-outlined/512/linkedin.png"
                                                                             width="20" height="20" title="LinkedIn"/></a>
                                                                         <!--<a href="https://www.instagram.com/propavconstrucaoemontagem/"><img src="https://propav.com.br/wp-content/uploads/2021/10/propav-assinatura-e-mail-icone-instagram.png" width="20" height="20" title="Instagram" /></a>-->
                                                                         <a href="https://www.youtube.com/channel/UCdqyxPb2s5kkva2Ia7mGaZQ"><img
                                                                                 src="https://img.icons8.com/material-outlined/512/youtube-play.png"
                                                                                 width="20" height="20" title="YouTube"/></a>
                                                                         <a href="https://ethicspeakup.com.br/tamoios/"><img
                                                                                 src="https://img.icons8.com/ios-glyphs/512/commercial.png"
                                                                                 width="20" height="20"
                                                                                 title="Canal de Denúncia"/> </a></td>
     
                                                                 <tr>
                                                                     <td align="justify" colspan="18"
                                                                         style="width: 575px; padding-top: 20px; padding-bottom: 10px; font-size: 9px; color: #333c42; line-height: 12px;">
                                                                         Em conformidade com a exigência do art. 7º da Lei nº
                                                                         13.709/2018 (Lei Geral de Proteção de Dados – LGPD),
                                                                         todos os dados pessoais objeto de tratamento foram
                                                                         consentidos pelos seus titulares, em cumprimento à
                                                                         obrigação legal e em observância à finalidade
                                                                         definida pelo Controlador, respeitando-se os
                                                                         direitos dos titulares indicados no art. 18 da Lei,
                                                                         bem como a adoção de todas as medidas necessárias e
                                                                         cabíveis à proteção contra acessos não autorizados,
                                                                         incidentes e tratamento inadequado, estando sujeito
                                                                         às penalidades previstas na Lei.
     
                                                                     </td>
                                                                 </tr>
                                                                 </tr>
                                                                 </tbody>
                                                             </table>
                                                         </center>
                                                     </td>
                                                 </tr>
                                                 <tr>
                                                     <td style="word-break: break-word; font-family: Arial,sans-serif; border-collapse: collapse;"></td>
                                                 </tr>
                                                 </tbody>
                                             </table>
                                         </center>
                                     </td>
                                 </tr>
                                 </tbody>
                             </table>
                             <table id="x_blankSpacea6849bce-b5d6-421a-9901-67787c142474" class="x_mktoModule x_m_blankSpace"
                                    style="border-spacing: 0; border-collapse: collapse;" border="0" width="100%"
                                    cellspacing="0" cellpadding="0" align="center">
                                 <tbody>
                                 <tr>
                                     <td style="word-break: break-word; font-family: Arial,sans-serif; border-collapse: collapse; background-color: #ebeff2;"
                                         valign="top" bgcolor="#EBEFF2">
                                         <table class="x_table600"
                                                style="border-spacing: 0px; border-collapse: collapse; margin: 0px auto; height: 61px;"
                                                border="0" width="452" cellspacing="0" cellpadding="0" align="center">
                                             <tbody>
                                             <tr>
                                                 <td class="x_primary-font x_title"
                                                     style="font-family: Arial, sans-serif; font-size: 60px; line-height: 90%; color: #32ad84; text-align: left; border-collapse: collapse; width: 450px;">
                                                     <div id="x_copyright" class="x_mktoText">
                                                         <div class="x_p1" style="text-align: center;"><span
                                                                 style="color: #828f9d; font-size: 12px;"> © 2022 Concessionária Tamoios - Powered by Gabriel Rosa & Rafael Souza. </span>
                                                         </div>
                                                     </div>
                                                 </td>
                                             </tr>
                                             </tbody>
                                         </table>
                                     </td>
                                 </tr>
                                 </tbody>
                             </table>
                         </td>
                     </tr>
                     </tbody>
                 </table>
             </td>
         </tr>
         </tbody>
     </table>
     
"@
 
}

if ($HTML) {
    # Script para o HTML funcionar junto com o Powershell
    $table  = ($Report | ConvertTo-Html -Fragment) -join [Environment]::NewLine
    $output = $htmlBegin + ($htmlEnd -f $date, $table)
}
else {
    $table  = $Report | Format-Table -AutoSize | Out-String
    $output = $plainText -f $date, $table
}

           $SMTPMessage = New-Object System.Net.Mail.MailMessage($EmailFrom,$sendTo,$emailSubject,$emailBody)
           $SMTPMessage.IsBodyHTML = $true
           $SMTPClient.Send($SMTPMessage)
        }
    } elseif ($daysRmmaining -lt 0) {
        # Cria uma lista com os usuários em que a senha já passou do prazo de expiração.
        $userMail = $user.mail
        $AlreadyExpiredList = $AlreadyExpiredList + "$usersName, $userMail, $ExpireDate_String</br>"
    }    
 
# Lista todos os usuários que estão com a senha expirada para o TI ADM.
if ($null -ne $AlreadyExpiredList)
{
    $sendToAlreadyExpired = "<e-mail do TI>"
    $subjectAlreadyExpired = "A senha desses usuários expiraram, talvez eles necessitem de suporte."
 
    $SMTPMessage = New-Object System.Net.Mail.MailMessage($EmailFrom,$sendToAlreadyExpired,$subjectAlreadyExpired,$AlreadyExpiredList)
    $SMTPMessage.IsBodyHTML = $true
    $SMTPClient.Send($SMTPMessage)
}