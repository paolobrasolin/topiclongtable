# topiclongtable

Development of this package was sponsored by Human Predictions, LLC (<http://www.humanpredictions.com>).

This package was developed by Paolo Brasolin (<paolo.brasolin@gmail.com>).

This package is licensed under MIT License.

---

This LaTeX package implements table cells that:

* collapse vertically if the cell above has the same content,
* prevents cells on the right from collapsing if the cell above has a different content,
* is well behaved with respect to `longtable` page breaks,
* and automatically draws the correct separation lines.

The typical use case is a table spanning multiple pages that contains a list of hierarchically organized topics (hence the package name).

## Usage

To use the package start by putting `topiclongtable.sty` in your document folder and requiring it in your preamble:

```tex
\usepackage{topiclongtable}
```

### Environment

The main feature is the `topiclongtable` environment, an enriched version of `longtable` whose usual features are therefore available.

```tex
\begin{topiclongtable}{...}
  ...
\end{topiclongtable}
```

To give the column specification you will have to prepend `F` to the first one and `T` to subsequent ones.

```tex
\begin{topiclongtable}{|Fl|Tl|Tl|Tl|}
  ...
\end{topiclongtable}
```

### Macros

#### Cells

To use the _smart_ cells you can use the `\Topic` macro as follows:

```tex
\begin{topiclongtable}{|Fl|Tl|Tl|Tl|}
  \Topic[Topic 1] & \Topic[Subtopic 1] & \Topic[Subsubtopic 1] & Foo \\
  \Topic          & \Topic             & \Topic[Subsubtopic 2] & Bar \\ 
  \Topic          & \Topic[Subtopic 1] & \Topic[Subsubtopic 2] & Baz \\ 
  \Topic[Topic 2] & \Topic[Subtopic 1] & \Topic[Subsubtopic 3] & Qux \\ 
  \Topic          & \Topic[Subtopic 2] & \Topic[Subsubtopic 4] & Zod \\ 
  \Topic          & \Topic             & \Topic                & Bop \\
\end{topiclongtable}
```

would render to

```
| Topic 1 | Subtopic 1 | Subsubtopic 1 | Foo |
|         |            | Subsubtopic 2 | Bar |
|         |            |               | Baz |
| Topic 2 | Subtopic 1 | Subsubtopic 3 | Qux |
|         | Subtopic 2 | Subsubtopic 4 | Zod |
|         |            |               | Bop |
```

The main features of `\Topic` are demonstrated:

* the parameter is optional,
* merging happens when it's omitted (rows 1-3 on column 1),
* merging happens when it's value is equal to the preceeding one (rows 2-3 on columns 2 and 3),
* merging does not happen (rows 3-4 on column 1) when the hierarchy is reset by the appearance of a new value in a column on the left (by row 4 column 1).

#### Lines

By default no horizontal lines are drawn on top and bottom of table chunks to allow for maximal flexibility. You can use `longtable` footer and headers to easily draw them (or whichever footer/header you may desire).

```tex
\begin{topiclongtable}{|Fl|Tl|Tl|Tl|}
  \hline\endhead
  \hline\endfoot
  ...
\end{topiclongtable}
```

Furthermore, you can use the `\TopicLine` to automatically draw the horizontal lines between the rows:

```tex
\begin{topiclongtable}{|Fl|Tl|Tl|Tl|}
  \hline\endhead
  \hline\endfoot
  \Topic[Topic 1] & \Topic[Subtopic 1] & \Topic[Subsubtopic 1] & Foo \\
  \Topic          & \Topic             & \Topic[Subsubtopic 2] & Bar \\ 
  \Topic          & \Topic[Subtopic 1] & \Topic[Subsubtopic 2] & Baz \\ 
  \Topic[Topic 2] & \Topic[Subtopic 1] & \Topic[Subsubtopic 3] & Qux \\ 
  \Topic          & \Topic[Subtopic 2] & \Topic[Subsubtopic 4] & Zod \\ 
  \Topic          & \Topic             & \Topic                & Bop \\
\end{topiclongtable}
```

would render to

```
|---------|------------|---------------|-----|
| Topic 1 | Subtopic 1 | Subsubtopic 1 | Foo |
|         |            | ------------- | --- |
|         |            | Subsubtopic 2 | Bar |
|         |            |               | --- |
|         |            |               | Baz |
|---------|------------|---------------|-----|
| Topic 2 | Subtopic 1 | Subsubtopic 3 | Qux |
|         | ---------- | ------------- | --- |
|         | Subtopic 2 | Subsubtopic 4 | Zod |
|         |            |               | --- |
|         |            |               | Bop |
|---------|------------|---------------|-----|
```

The killer feature of the package is that cell merging behaves nicely with `longtable` chunks. That is, if two page breaks were to happen after rows 2 and 5 of the previous example, the result would be

```
|---------|------------|---------------|-----|
| Topic 1 | Subtopic 1 | Subsubtopic 1 | Foo |
|         |            | ------------- | --- |
|         |            | Subsubtopic 2 | Bar |
|---------|------------|---------------|-----|

   ~~~ first page break ~~~

|---------|------------|---------------|-----|
| Topic 1 | Subtopic 1 | Subsubtopic 1 | Baz |
|---------|------------|---------------|-----|
| Topic 2 | Subtopic 1 | Subsubtopic 3 | Qux |
|         | ---------- | ------------- | --- |
|         | Subtopic 2 | Subsubtopic 4 | Zod |
|---------|------------|---------------|-----|

   ~~~ second page break ~~~

|---------|------------|---------------|-----|
| Topic 2 | Subtopic 2 | Subsubtopic 4 | Bop |
|---------|------------|---------------|-----|

```

### Settings

All settings described in this section are global and can be changed between tables.

#### Continuation mark

Cells _continuing_ from the previous page can be explicitly marked.
You can set a code fragment to append to such cells using `\TopicSetContinuationCode`.
E.g. 

```tex
\TopicSetContinuationCode{\ (cont.)}
```

By default no mark is appended and you can reset to the default using `\TopicSetContinuationCode{}`.

#### Cell vertical alignment

You can set the vertical position of the content for the topic cells by using `\TopicSetVPos`, e.g.

```tex
\TopicSetVPos{t}
```

Allowed values are `b` (bottom), `c` (center) and the default `t` (top).

#### Cell width

You can set the width of the topic cells by using `\TopicSetWidth`, e.g.

```tex
\TopicSetWidth{*}
```

Allowed values are `=` (fit column width) and the default `*` (fit natural content width).
