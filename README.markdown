


[![Stories in Ready](https://badge.waffle.io/JaredRoth/hyde.png?label=ready&title=Ready)](https://waffle.io/JaredRoth/hyde)		
# Hyde
Hyde is the first paired project in Module 1 at the Turing School. Students build a lightweight application for blogging that provides a file structure and templates for users to make posts and pages in easy-to-read markdown language.

[Project Spec](https://github.com/turingschool/curriculum/blob/master/source/projects/hyde/index.markdown)

### Getting Started:

 - Clone this project by running `git clone https://github.com/JaredRoth/hyde.git`
 - Run `bundle`
 - To create a new file structure, run `bin/hyde new /file_path/ `
 - To create a new post, run `bin/hyde post /file_path/ "name of your post"`
 - Edit the provided markdown files or any posts you create
 - To build your project into functional html, run `bin/hyde build /file_path/`.
 - Alternately, you can record changes as you make them and be reminded to build afterward. To do so run `bin/hyde watch /file_path/ (# of minutes)`

**'new' makes this structure:**
```
.
├── _output
└── source
    ├── css
    │   └── main.css
    ├── index.markdown
    ├── pages
    │   └── about.markdown
    └── posts
        └── 2016-02-20-welcome-to-hyde.markdown
```
**'build' makes the following structure:**

Calling 'build' will read all files from the `source` directory and copy them over the the `_output` directory. In this process, it will automatically convert any markdown files it encounters into html.
```
.
├── _output
│   ├── css
│   │   └── main.css
│   ├── index.html
│   ├── pages
│   │   └── about.html
│   └── posts
│       └── 2016-02-20-welcome-to-hyde.html
└── source
    ├── css
    │   └── main.css
    ├── index.markdown
    ├── pages
    │   └── about.markdown
    └── posts
        └── 2016-02-20-welcome-to-hyde.markdown
```

### Learning Goals

 - Use tests to drive both the design and implementation of code
 - Decompose a large application into components
 - Use test fixtures instead of actual data when testing
 - Connect related objects together through references
 - Learn an agile approach to building software
