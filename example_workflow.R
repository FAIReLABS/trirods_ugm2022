# install.packages("devtools")

# this my current development branch
devtools::install_github("martinschobben/irods_client_library_rirods", ref = "dev")

# load rirods
library(rirods)

# I will not show how to run an iRODS server or the Docker iRODS demo

# connect
create_irods("http://localhost/irods-rest/0.9.3", "/tempZone/home")


#-------------------------------------------------------------------------------
# I need this to have a user. These admin function are not core functionality
# So, you can do this also by using the iCommands.
#-------------------------------------------------------------------------------
# authenticate
iauth("rods", "rods")
# add user bobby
rirods:::iadmin(action = "add", target = "user", arg2 = "bobby", arg3 = "rodsuser")
# modify bobby's password
rirods:::iadmin(action = "modify", target = "user", arg2 = "bobby", arg3 = "password", arg4  = "passWORD")
#-------------------------------------------------------------------------------

# login as bobby
iauth("bobby", "passWORD")

# navigation
ipwd()
icd("..")
ipwd()
ils()
icd("bobby")
ils()

# make a dir
imkdir("test")
icd("test")
ipwd()

# Some objects
x <- 1:10
x

# Store
iput(x)
ils()

# get it back
iget("x")

# some plot
library(ggplot2)
p <- ggplot(iris, aes(x = Sepal.Width)) + geom_bar()

# store
iput(p)

# plot again
iget("p")

# some other format
foo <- data.frame(x = c(1, 8, 9), y = c("x", "y", "z"))

# creates a csv file of foo
library(readr)
write_csv(foo, "foo.csv")
list.files()

# store
iput("foo.csv")

# get it back
iget("foo.csv", overwrite = TRUE)
read_csv("foo.csv")

# metadata
imeta(
  "x", 
  "data_object", 
  operations = 
    list(operation = "add", attribute = "foo", value = "bar", units = "baz")
)

# check it
ils(metadata = TRUE)

# query
iquery("SELECT COLL_NAME, DATA_NAME WHERE COLL_NAME LIKE '/tempZone/home/%'")

# cleanup
ils()
irm("foo.csv", trash = FALSE)
irm("p", trash = FALSE)
irm("x", trash = FALSE)
ils()
icd("..")
irm("test", recursive = TRUE, trash = FALSE)
ils()