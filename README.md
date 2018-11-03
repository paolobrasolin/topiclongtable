# topiclongtable

This package is sponsored by Human Predictions, LLC (<http://www.humanpredictions.com>).

This package is developed by Paolo Brasolin (<paolo.brasolin@gmail.com>).

This package is licensed under MIT License.

---

This LaTeX package extends `longtable` implementing cells that:

* merge with the one above if it has the same content,
* do not merge with the one above unless the ones on the left are merged,
* are well behaved with respect to `longtable` chunking on page breaks,
* and automatically draw the correct separation lines.

The typical use case is a table spanning multiple pages that contains a list of hierarchically organized topics (hence the package name).

