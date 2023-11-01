---
layout: post
title: Learn your levels, master your levels
date: 2023-10-31 18:15:00
categories: [English only, programming]
---

![English trifle](/assets/img/master-levels-thumbnail.jpg)

There is no point where a developer stops thinking about ways of improving the quality of the code one writes. Patterns, SOLID, KISS, DRY, YAGNI, TDD etc. So many abbreviations and rules developers come up with while trying to improve their skills communicating with machines and being clear to other developers.

When you develop a new system or a module of a system or a big feature it's cool to think about a pattern or a set of patterns to use, drawing diagrams and schemes, etc. But if you don't have time for all that stuff you probably just use the "let's code as we go" rule. You don't want to draw diagrams and flow charts. At the end of the day it's just a set of functions and files which do the job, you don't know their specifics yet so you just start coding and adding them one by one as you go.

On that note, let me ask you a question: how often do you rewrite parts of your code, refactor it or even start from scratch because you realize something doesn't work or is not going to work, or you just don't like how it looks? It happens to me from time to time. So, how to avoid it and be better at the beginning? 

## Oh my levels

Let's learn from frameworks. If you ever checked how frameworks work then you know that they always consist of levels. You might have or might have not noticed that, but even majority of your programs probably consist of levels. 

There is the business logic level, utility level (like reading files, database), helper functions and one or more intermediate levels between business logic and utility. Those levels could be partially business logic and partially utility. To not overcomplicate let's say that for each level you want to have its "level functions" and the rule of thumb is a level function can interact only with the first lower level functions or helpers functions if needed.

Let me give you an example:

- Business logic level functions - `register()`, `login()`, `logout()`
- Intermediate level: `validate()`, `saveUser()`, `findUserByEmail()`, `deleteSession()`
- Utility level: programming language functions like db driver functions, working with files, http request/response, etc., or wrapper functions to compose those together by a meaning.

In real world, depending on program compexity you probably want to have more than one level for business logic or utility level to wrap the language functions with some sort of abstractions etc.

The important point of levels is when you "code as you go" do not jump between those levels. Start with the higher level, describe an action by what lower level functions are needed and then go to the lower level functions. First `register()`, from there you know that you need to `validate()` the user and `saveUser()` if valid, but write the complete high level function and then go lower, it helps you stay focused on one problem. How do I register a user? How do I validate user data? Where and how do I save user? If you need a helper function, just pretend that you already have it and you know what is the input and what's the output.

This approach might sound similar to TDD and you can definetely write unit tests in parallel while you are building those levels if you are planning to have tests for your program.

## Errors/Exceptions handling

Error handling is hard. Additionally you have to handle the fact that developers are lazy. So, when one writes a program -- the easiest solution to handle an error is "Ops! Something went wrong". But if you want your code to be clear you have to spend some time on error handling.  

We already know that a function should only call a function one level below. Similarly to that rule an upper level should only handle errors from one level below. If a function expects an error or an exception from a lower level function it calls then ideally you want to convert that error to something that suits the caller function level. For example if `saveUser()` catches DB exception `duplicate entry ...` then convert it to `UserExistsException`. This helps you handle errors and exceptions on the very top level without mixing errors from all the levels below.

Another rule is reducing variety of errors that lower level throws. A function that calls lower level function should filter those errors and group by a meaning. For example, DB might return different errors like SQL syntax error, column can't be null, constraints errors, etc., but for the `saveUser()` function it's just `unable to save user` error. When you need more details the logs always can tell you.

## Logging

One extra tip is suggestion for logging. It says: do NOT spread logs among all the levels! There are only two levels where you should write logs - business logic and utility levels. Small clarification, if we call utility level the dependency level then it'll make more sense. Database is one dependency so it has its own logs, an API client another dependency and has its own logs, email client has its own logs, etc. Then when you work on a bug you again stay focused on a specific problem. Something weird happens on a user log out? Check business logic logs. A user does not receive the email? Start with the email client logs.

## Must and should rules

While reading the suggestions above you might agree and disagree with some of the rules and that's probably good. Exceptions always exist and you shouldn't blindly follow the rules. I believe you start writting a better code only when you question yourself. If you asked me what are mine must and should rules then the answer would be next: the logging is a should rule and none of the rest is a must rule but the less exceptions you are doing initally the happier you are later.

Use these rules as starting point. Try to keep them in mind especially during the initial phase of developing your program or feature. Later your will have a good skeleton for it and will see the full picture. 
