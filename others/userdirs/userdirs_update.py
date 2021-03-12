#!/usr/bin/env python
import os
import shutil
from pathlib import Path


new_names = {
    "Escritorio": "Escritorio",
    "Descargas": "descargas",
    "Plantillas": "templates",
    "Público": "publico",
    "Documentos": "documentos",
    "Música": "musica",
    "Imágenes": "imagenes",
    "Vídeos": "videos",
}


# Rename user dirs
try:
    for old_name, new_name in new_names.items():
        old_dir = Path.joinpath(Path.home(), old_name)
        if Path.is_dir(old_dir):
                os.rename(old_dir, Path.joinpath(Path.home(), new_name))
except Exception as e:
    print(e)
else:
    # Copy user-dirs.dirs file to ~/.config
    new_userdirs_file = os.path.join(
        os.path.dirname(os.path.realpath(__file__)),
        "user-dirs.dirs"
    )
    userdirs_path = Path.joinpath(Path.home(), ".config")
    shutil.copy(new_userdirs_file, userdirs_path)

    # Update xdg-userdirs
    os.system("xdg-user-dirs-update")
