# crocodealer

[![Hackage](https://img.shields.io/hackage/v/crocodealer.svg?logo=haskell)](https://hackage.haskell.org/package/crocodealer)
[![MPL-2.0 license](https://img.shields.io/badge/license-MPL--2.0-blue.svg)](LICENSE)
[![Stackage Lts](http://stackage.org/package/crocodealer/badge/lts)](http://stackage.org/lts/package/crocodealer)
[![Stackage Nightly](http://stackage.org/package/crocodealer/badge/nightly)](http://stackage.org/nightly/package/crocodealer)
[![Build status](https://img.shields.io/travis/kowainik/crocodealer.svg?logo=travis)](https://travis-ci.org/kowainik/crocodealer)

This tool helps managing multiple GitHub repos in the organization or personal accounts by automatically submitting file patches, label and issue updates.

## Motivation

We have the `org` repository which contains different meta-templates like CONTRIBUTING guide or `stylish-haskell`
configuration. If something changes (typos, format change), it would be much nicer to change in a single place (`org` repo)
and then update all other repositories automatically. `crocodealer` is flexible enough, so other organizations or individual
users can apply it to support their own workflows in similar manner.

## Features

What this tool should do: update all repositories in batches. Typical workflows include:

1. Create/override same set of labels in all repositories. Same color, same name, same description. 
   This helps with consistency.
2. Propagate file updates.
3. Run some checks over all repositories. For example, check whether they all have LICENSE, CONTRIBUTING, README files (etc.). 


## Prerequisites

To start using Crocodealer make sure that you have the following tools installed on your machine:

* [`curl`](https://curl.haxx.se) – to download files.
