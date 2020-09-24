




# Ajout de la Prompt config dnas le profil de root

echo " "  >> /root/.bash_profile
echo "# Alex Prompt config" >> /root/.bash_profile
PS1="\e[40;0;33m\u@\h \e[40;1;34m[\w]\e[40;0;37m$ "
echo "PS1=\"$PS1\"" >> /root/.bash_profile

