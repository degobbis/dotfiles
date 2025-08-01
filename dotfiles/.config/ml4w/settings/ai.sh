JANAI=$(basename $(ls .local/share/applications/appimagekit_*-Jan.desktop))
LLMS=$(basename $(ls .local/share/applications/appimagekit_*-LM_Studio.desktop))
gtk-launch $LLMS
