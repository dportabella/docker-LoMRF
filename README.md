# LoMRF docker image

Run LoMRF software in any computer without the need of compiling it.

https://github.com/anskarl/LoMRF

Note: Follow this doc [install LoMRF on Ubuntu](https://github.com/dportabella/docker-lomrf/blob/master/INSTALL_LOMRF_ON_UBUNTU.md) or [install LoMRF on OSX](https://github.com/dportabella/docker-lomrf/blob/master/INSTALL_LOMRF_ON_OSX.md) if you don't want to use a Docker image.


## Example

Install [Docker](https://www.docker.com/), and then execute this command to download and start a docker container with the LoMRF software installed:

```
$ docker run -ti --rm dportabella/docker-lomrf bash

# Get a license if you are using the Gurobi solver:
# Unfortunatelly you won't be able to use the free single-machine academic license, since this is running in a floating container (docker),
# so you need to contact them and ask for a "free multi-user academic site license (Unlimited-Simultaneous-Use, Floating-Use academic license)".
# http://www.gurobi.com/ -> Get Gurobi -> For Academic Users -> Visit our Academia Center -> Get the Right License -> Academic Licenses
# Follow instructions to create the file /opt/gurobi/gurobi.lic (you will need to execute this command with the provided code)
# grbgetkey ........-....-....-.................

# Otherwise, install LoMRF on your machine without using Docker, as explained at the top.


$ git clone https://github.com/anskarl/LoMRF-data

$ cd LoMRF-data/Examples/Weight_Learning/Friends_Smokers

$ git checkout -b develop remotes/origin/develop  # it has also smoking-test.db

$ ls -l
total 40
-rwxr-xr-x  1 david  wheel  321 Nov 10 13:06 run-mm.sh
-rw-r--r--  1 david  wheel  210 Nov 10 13:06 smoking-test.db
-rw-r--r--  1 david  wheel  423 Nov 10 12:14 smoking-train.db
-rw-r--r--  1 david  wheel  363 Nov 10 12:14 smoking.mln


$ cat smoking.mln
// MLN for social networks section in tutorial

// Evidence
Friends(person, person)

// Some evidence, some query
Smokes(person)

// Query
Cancer(person)

// Rules
// If you smoke, you get cancer
Smokes(x) => Cancer(x)

// People with friends who smoke, also smoke
// and those with friends who don't smoke, don't smoke
Friends(x, y) => (Smokes(x) <=> Smokes(y))


$ cat smoking-train.db
Friends(Anna, Bob)
Friends(Bob, Anna)
Friends(Anna, Edward)
Friends(Edward, Anna)
Friends(Anna, Frank)
Friends(Frank, Anna)
Friends(Bob, Chris)
Friends(Chris, Bob)
Friends(Chris, Daniel)
Friends(Daniel, Chris)
Friends(Edward, Frank)
Friends(Frank, Edward)
Friends(Gary, Helen)
Friends(Helen, Gary)
Friends(Gary, Anna)
Friends(Anna, Gary)

Smokes(Anna)
Smokes(Edward)
Smokes(Frank)
Smokes(Gary)

Cancer(Anna)
Cancer(Edward)


$ lomrf wlearn \
	-i smoking.mln \
	-t smoking-train.db \
	-o smoking-learned.mln \
	-ne Smokes/1,Cancer/1


$ cat smoking-learned.mln
// Predicate definitions
Friends(person,person)
Smokes(person)
Cancer(person)

// Clauses
-0.499999999997 !Smokes(x) v Cancer(x)

-0.041666666668 !Friends(x,y) v !Smokes(x) v Smokes(y)

-0.041666666668 !Friends(x,y) v Smokes(x) v !Smokes(y)


$ lomrf infer \
	-inferType map \
	-mapType ilp \
	-i smoking-learned.mln \
	-r map.result \
	-e smoking-test.db \
	-q Smokes/1,Cancer/1


$ cat map.result
Cancer(Nick) 0
Cancer(Michael) 0
Cancer(Lars) 0
Cancer(Katherine) 0
Cancer(John) 0
Cancer(Ivan) 0
Smokes(Michael) 1
Smokes(Lars) 1
Smokes(Katherine) 1
Smokes(John) 1
```


Disclaimer: I am not affiliated to the authors of the [LoMRF](https://github.com/anskarl/LoMRF) software.
