import os
from ranger.api import register_linemode
from ranger.core.linemode import LinemodeBase
from .devicons import *


@register_linemode
class DevIconsLinemode(LinemodeBase):
  name = "devicons"
  uses_metadata = False

  def filetitle(self, file, metadata):
    sep = os.getenv('RANGER_DEVICONS_SEPARATOR', ' ')
    path = file.relative_path
    tail = "/" if file.is_directory else ""
    return devicon(file) + sep + path + tail
