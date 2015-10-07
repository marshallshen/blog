---
layout:     post
title:      Remove All Untagged Docker Images
date:       2015-10-03
categories: blog
tags:       [docker, rmi, docker-image]
---

In this micro blogpost I am going to show you how to *remove all untagged docker images*, inspired by [a similar blogpost](http://jimhoskins.com/2013/07/27/remove-untagged-docker-images.html) by Jim Hoskins.

### Remove all untagged docker images
Just run:

```
docker images | grep "<none>" | awk "{print \$3}" | xargs docker rmi
```

### Before the command
You may have something like the following in your machine:

![before docker cleanup images](/images/before_docker_cleanup_images.png)

### After the command
You may have something like the following in your machine. **You will still have untagged images if the untagged images are being used by some Docker containers**.

![after docker cleanup images](/images/after_docker_cleanup_images.png)

### Break down the command

The chained command can be parsed in *three* sequences:

```
docker images | grep "<none>"
```

The above command grabs all *rows* that have "<none>" in the line

```
docker images | grep "<none>" | awk "{print \$3}"
```

The above command grabs all *rows* that have "<none>" in the line, AND fetch the third argument of each line.

```
docker images | grep "<none>" | awk "{print \$3}" | xargs docker rmi
```

Lastly, the above command feeds the array of third arguments of "<none>" matched docker images, and call `docker rmi` upon it.