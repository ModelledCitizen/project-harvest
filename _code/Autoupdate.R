#      __  __            __   _               __          __
#     / / / /___  ____  / /__(_)___  _____   / /   ____ _/ /_
#    / /_/ / __ \/ __ \/ //_/ / __ \/ ___/  / /   / __ `/ __ \
#   / __  / /_/ / /_/ / ,< / / / / (__  )  / /___/ /_/ / /_/ /
#  /_/ /_/\____/ .___/_/|_/_/_/ /_/____/  /_____/\__,_/_.___/
#             /_/
#
#   Title: Automatic Updates
#  Author: UnlikelyVolcano
# Updated: 14 April 2020
#   Notes:
#

# Working Directory -------------------------------------------------------

UnlikelyTools::set_wd("project-harvest")


# Update Data -------------------------------------------------------------

source("_code/RCP_Polls.R")

source("_code/NYT_Results.R")


# Push to Repo ------------------------------------------------------------

system("git add .; git commit -m 'Automatic update'")
system("git push")
