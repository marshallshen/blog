---
layout:     post
title:      Build RESTful API microservice with Go
date:       2017-08-11
categories: blog
tags: ["Golang", "microserivce", "API"]
blog: true
---

**Note** you can find the codebase for the blog post in this [Github repo](https://github.com/marshallshen/instructions).

We can’t skip the conversation of microservices when we talk about service-oriented architecture. Growth companies face the challenge of scaling technical applications to meet business needs. The trend of microservices is also promoted along with some new technology that allows developers to build API based service faster.

Recently I have been researching [Golang](https://golang.org/) and how to use it to build microservices. This blogpost documents my findings.

## Objective

I lay out certain criteria to evaluate whether Golang is a suitable tool for building microservices, I deem these criteria as an important guide in building a microservices, which can be further applied in evaluating other language and frameworks.

* **API-readiness**. The framework **must** fully support `HTTP/HTTPs` protocol and `JSON` content type. The framework **must** provide competent middleware for instrumentation, the framework also must provide webdriver that meets minimum requirement of service-level agreement such as `requests per minute`.

* **Testability**. The framework **must** allow tests on the `module` level and `integration` level. In the scope of building RESTful APIs, the framework **must** support testing of basic `HTTP/HTTPs` calls, such as `GET`, `PUT`, `POST` methods.

* **Deployability**. The framework **must** allow `Docker` deployments, the community behind the lanuage **should** have a stable Docker image that allow developers to easily deploy application to container hosts such as Amazon Elastic Container Service.

* **Adaptability**. The framework **should** be relatively easy to learn. A team of developers should be able to be productive using the framework in 2-month period. Note that 2 months is based on my prior experience of learning new technology.

## Experiment

To start the experiment, I decided to build an **instruction service** using [Gin](https://github.com/gin-gonic/gin) as the Golang web server. The instruction service is simple to service that serves instructions based on RESTful API. Additionally, I choose `Gin` as the framework because the community behind the framework is [active](https://github.com/gin-gonic/gin/pulse), and comparing to other frameworks such as [Martini](https://github.com/go-martini/martini), the set up is light weight, the syntax is easy to understand.


### Set up webserver

Inside `main.go`, we set up the router for `api/v1/`.

```go
package main

import (
  "github.com/gin-gonic/gin"
  "fmt"
)

func SetupRouter() *gin.Engine {
  router := gin.Default()

  v1 := router.Group("api/v1") 
  {
    v1.GET("/instructions", GetInstructions)
  }

  return router
}

func GetInstructions(c *gin.Context) {
  c.JSON(200, gin.H{"ok": "Welcome to Chicago!"})
  // curl -i http://localhost:8080/api/v1/Instructions
}

func main() {
  router := SetupRouter()
  router.Run(":8080")
}
```

After you start the server using `go main.go`, This file should serve response of **"ok": "Welcome to Chicago!"** when you hit `http://localhost:8080/api/v1/Instructions`.

In preparation of adding more logic, we can move business logic into `app` folder. We can create a app folder and add `app.go`:

```go
package app

import (
  "strconv"
  "github.com/gin-gonic/gin"
)

func GetInstructions(c *gin.Context) {
  c.JSON(200, gin.H{"ok": "GET api/v1/instructions"})
}

func GetInstruction(c *gin.Context) {
  c.JSON(200, gin.H{"ok": "GET api/v1/instructions/1"})
}

func PostInstruction(c *gin.Context) {
  c.JSON(200, gin.H{"ok": "POST api/v1/instructions"})

}

func UpdateInstruction(c *gin.Context) {
  c.JSON(200, gin.H{"ok": "PUT api/v1/instructions/1"})

}

func DeleteInstruction(c *gin.Context) {
  c.JSON(200, gin.H{"ok": "DELETE api/v1/instructions/1"})
}
```


Then inside `main.go`, we can point the request handler to `app`:


```go
package main

import (
  "github.com/gin-gonic/gin"
  "./app"
)

func SetupRouter() *gin.Engine {
  router := gin.Default()

  v1 := router.Group("api/v1") 
  {
    v1.GET("/instructions", app.GetInstructions)
    v1.GET("/instructions/:id", app.GetInstruction)
    v1.POST("/instructions", app.PostInstruction)
    v1.PUT("/instructions/:id", app.UpdateInstruction)
    v1.DELETE("/instructions/:id", app.DeleteInstruction)
  }

  return router
}

func main() {
  router := SetupRouter()
  router.Run(":8080")
}
```

### Struct and database

We need to restore **Instruction** object into a database, to do that we need to use [Struct](https://tour.golang.org/moretypes/2) type, which can capture a collection of fields with strict typing. We have only three fields in the database table: an integer `Id` as the primary key, `EventStatus` as a string, and `EventName` as a string.

```go

type Instruction struct {
 Id int64
 EventStatus string
 EventName string
}

```

Next, we need to connect the web service with a database, we choose `MySQL` as the database and [MySQL go-sql-driver](https://github.com/go-sql-driver/mysql) as the database driver. To do that, we create a db.go inside app folder because it belongs to the same package **app**.


```go
package app

import (
  "database/sql"
  _ "github.com/go-sql-driver/mysql"
  "gopkg.in/gorp.v1"
  "log"
)

func initDb() *gorp.DbMap {
  db, err := sql.Open("mysql", "root:password@/instructions")
  checkErr(err, "sql.Open failed")

  dbmap := &gorp.DbMap{Db: db, Dialect: gorp.MySQLDialect{"InnoDB", "UTF8"}}
  dbmap.AddTableWithName(Instruction{}, "Instruction").SetKeys(true, "Id")

  err = dbmap.CreateTablesIfNotExists()
  checkErr(err, "Create table failed")
  return dbmap
}

func checkErr(err error, msg string) {
  if err != nil {
    log.Fatalln(msg, err)
  }
}
```

Inside `app.go`, we can declare dabatase level typing back to our original struct, and we can initialize webdriver client by calling `initDb()`

```go
type Instruction struct {
 Id int64 `db:"id" json:"id"`
 EventStatus string `db:"event_status" json:"event_status"`
 EventName string `db:"event_name" json:"event_name"`
}

var dbmap = initDb()
```

Now that we have router setup and database connection established, let's backfill our RESTful APIs with real actions:

```go
func GetInstruction(c *gin.Context) {
  id := c.Params.ByName("id")
  var instruction Instruction
  
  err := dbmap.SelectOne(&instruction, "SELECT * FROM instruction WHERE id=?", id)
  if err == nil {
    instruction_id, _ := strconv.ParseInt(id, 0, 64)
  
    content := &Instruction{
      Id: instruction_id,
      EventStatus: instruction.EventStatus,
      EventName: instruction.EventName,
    }
 
    c.JSON(200, content)
  } else {
    c.JSON(404, gin.H{"error": "instruction not found"})
  }
  // curl -i http://localhost:8080/api/v1/Instructions/1
}

func PostInstruction(c *gin.Context) {
  var instruction Instruction
  c.Bind(&instruction)

  if instruction.EventStatus != "" && instruction.EventName != "" {
    if insert, _ := dbmap.Exec(`INSERT INTO instruction (event_status, event_name) VALUES (?, ?)`, instruction.EventStatus, instruction.EventName); insert != nil {
      instruction_id, err := insert.LastInsertId()
      if err == nil {
        content := &Instruction{
          Id: instruction_id,
          EventStatus: instruction.EventStatus,
          EventName: instruction.EventName,
        }
        c.JSON(201, content)
      } else {
        checkErr(err, "Insert failed")
      }
    }
  } else {
    c.JSON(422, gin.H{"error": "fields are empty"})
  }
  // curl -i -X POST -H "Content-Type: application/json" -d "{ \"event_status\": \"83\", \"event_name\": \"100\" }" http://localhost:8080/api/v1/instructions
}

func UpdateInstruction(c *gin.Context) {
  // ... more code...
  // curl -i -X PUT -H "Content-Type: application/json" -d "{ \"event_status\": \"83\", \"event_name\": \"100\" }" http://localhost:8080/api/v1/instructions/1
}

func DeleteInstruction(c *gin.Context) {
  // ... more code...
  // curl -i -X DELETE http://localhost:8080/api/v1/instructions/1
}

```
You can find complete code [here](https://github.com/marshallshen/instructions/blob/master/app/app.go)

### Testing

Golang provides a package [testing](https://golang.org/pkg/testing/) to write tests. Two conventions **must** be followed to write tests, which is noted in testing API documentation:

> Package testing provides support for automated testing of Go packages. It is intended to be used in concert with the “go test” command, which automates execution of any function of the form
>  **func TestXxx(*testing.T)**

**Gin** also provides testing mode for writing API level tests along with [Golang httptest](https://golang.org/pkg/net/http/httptest/), we then can start writing integration tests under `main_test.og` following testing convention. For example, we can test that our POST endpoint functions as expected:

```go
package main

import (
  "bytes"
  "github.com/gin-gonic/gin"
  "net/http"
  "net/http/httptest"
  "testing"
)

func TestPostInstruction(t *testing.T) {
  gin.SetMode(gin.TestMode)
  testRouter := SetupRouter()

  body := bytes.NewBuffer([]byte("{\"event_status\": \"83\", \"event_name\": \"100\"}"))

  req, err := http.NewRequest("POST", "/api/v1/instructions", body)
  req.Header.Set("Content-Type", "application/json")
  if err != nil {
    t.Errorf("Post hearteat failed with error %d.", err)
  }

  resp := httptest.NewRecorder()
  testRouter.ServeHTTP(resp, req)

  if resp.Code != 201 {
    t.Errorf("/api/v1/instructions failed with error code %d.", resp.Code)
  }
}
```
Comparing to other testing framework such as [RSpec in Rails](https://github.com/rspec/rspec-rails), testing in Golang seems less elegant. However, the code seems less magical comparing to other dynamic languages like Ruby.

You can find the complete testing code [here](https://github.com/marshallshen/instructions/blob/master/main_test.go).

## Deployment

Docker image for golang is well supported and there are many established **Dockerfile** for `Gin` framework, one thing we need to watch out is the dependency based on package we introduced. Unfortunately, it does not seem like there is a centralized place inside my Golang app to manage package dependency. Below is my Dockerfile:

```sh
FROM        golang:1.8
MAINTAINER  Marshall Shen <marshall@test.com>

ENV     PORT  8080
   
# Setting up working directory
WORKDIR     /go/src/gin-container
ADD         . /go/src/gin-container

RUN     go get github.com/tools/godep
RUN     go get github.com/gin-gonic/gin
RUN     go get gopkg.in/gorp.v1
RUN     go get github.com/go-sql-driver/mysql
RUN     go install github.com/tools/godep
RUN     go install github.com/gin-gonic/gin

# Restore godep dependencies
#RUN godep restore

EXPOSE 8080
ENTRYPOINT  ["/usr/local/bin/go"]
CMD     ["run", "main.go"]
```

## Evaluation

Based on the research, Golang and Gin seems like a great fit for building a microservice in handling a very specific task, such as serving RESTful API. The framework is API-ready, provides tools for testing and is easily deployable with Docker.

Conceptually, I am confident that this framework is great at handling tasks such as web scrapping, ETL pipeline, or media transcoding. However, I am not confident that the framework is designed for building applications that encompass complicated business logic, such as a client-facing web application. There are several aspects of a framework I’d like to investigate more in the future:

* **Database migration tool**. How easy is it to track SQL schema migration within a Golang app?
* **Multiple environment support** What is the best practice for deploying a Golang app into multiple environments with different configurations?
* **Package management** How can we manage package dependencies within a Golang app?



