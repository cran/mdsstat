context("BCPNN Algorithm")

# Reference example
data <- data.frame(time=c(1:25),
                   nA=as.integer(stats::rnorm(25, 25, 5)),
                   nB=as.integer(stats::rnorm(25, 50, 5)),
                   nC=as.integer(stats::rnorm(25, 100, 25)),
                   nD=as.integer(stats::rnorm(25, 200, 25)))
a2 <- bcpnn(data)

# Basic
# -----

# Return behavior
test_that("function returns the correct class", {
  expect_is(a2, "list")
  expect_is(a2, "mdsstat_test")
})
test_that("function returns core mdsstat_test components", {
  expect_true(all(names(a2) %in% c("test_name",
                                   "analysis_of",
                                   "status",
                                   "result",
                                   "params",
                                   "data")))
})
test_that("BCPNN outputs are as expected", {
  expect_equal(a2$test_name, "BCPNN")
  expect_equal(a2$analysis_of, NA)
  expect_true(a2$status)
  expect_true(all(names(a2$result) %in% c("statistic",
                                          "lcl",
                                          "ucl",
                                          "p",
                                          "signal",
                                          "signal_threshold",
                                          "quantiles")))
  expect_true(a2$result$statistic > 0)
  expect_true(a2$result$lcl > 0)
  expect_true(a2$result$ucl > 0)
  expect_true(a2$result$ucl > a2$result$lcl)
  expect_true(a2$result$p > 0)
  expect_is(a2$result$signal, "logical")
  expect_equal(as.numeric(a2$result$signal_threshold), 1)
  expect_true(all(names(a2$params) %in% c("test_hyp",
                                          "eval_period",
                                          "null_ratio",
                                          "conf_interval",
                                          "cont_adj")))
  expect_equal(a2$params$test_hyp,
               "5% quantile of the posterior distribution > 1")
  expect_is(a2$params$test_hyp, "character")
  expect_equal(a2$params$null_ratio, 1)
  expect_equal(a2$params$conf_interval, 0.9)
  expect_equal(a2$params$cont_adj, 0)
  expect_true(all(names(a2$data) %in% c("reference_time", "data")))
  expect_true(all(names(a2$data$data) %in% c("time_start", "time_end",
                                             "nA", "nB", "nC", "nD")))
  expect_equal(a2$data$reference_time[1], a2$data$data$time_start)
  expect_equal(a2$data$reference_time[2], a2$data$data$time_end)
  expect_equal(a2$data$data[, -c(1:2)], data.frame(t(colSums(data[nrow(data), -1]))))
})

# Reference example
data2 <- data
data2$nA <- 0
a2a <- bcpnn(data2)

test_that("test runs on 0 cell A counts", {
  expect_true(a2a$status)
})

# Reference example
data2 <- data
data2$nB <- 0
a2a <- bcpnn(data2)

test_that("test runs on 0 cell B counts", {
  expect_true(a2a$status)
})

# Reference example
data2 <- data
data2$nC <- 0
a2a <- bcpnn(data2)

test_that("test runs on 0 cell C counts", {
  expect_true(a2a$status)
})

# Reference example
data2 <- data
data2$nD <- 0
a2a <- bcpnn(data2)

test_that("test does not run on 0 cell D counts", {
  expect_true(!a2a$status)
})

# Reference example
data <- data.frame(time=c(1:25),
                   nA=as.integer(stats::rnorm(25, 25, 25)))
test_that("test errors on missing 2x2 cells", {
  expect_error(bcpnn(data))
})


# Parameter checks
# ----------------
data <- data.frame(time=c(1:25),
                   nA=as.integer(stats::rnorm(25, 25, 5)),
                   nB=as.integer(stats::rnorm(25, 50, 5)),
                   nC=as.integer(stats::rnorm(25, 100, 25)),
                   nD=as.integer(stats::rnorm(25, 200, 25)))
a2d <- data
a3d <- data
a3 <- bcpnn(a2d)

test_that("BCPNN df parameter functions as expected", {
  expect_is(a3, "list")
  expect_is(a3, "mdsstat_test")
  expect_true(all(names(a3) %in% c("test_name",
                                   "analysis_of",
                                   "status",
                                   "result",
                                   "params",
                                   "data")))
  expect_equal(a3$test_name, "BCPNN")
  expect_equal(a3$analysis_of, NA)
  expect_true(a3$status)
  expect_true(all(names(a3$result) %in% c("statistic",
                                          "lcl",
                                          "ucl",
                                          "p",
                                          "signal",
                                          "signal_threshold",
                                          "quantiles")))
  expect_true(a3$result$statistic > 0)
  expect_true(a3$result$lcl > 0)
  expect_true(a3$result$ucl > 0)
  expect_true(a3$result$ucl > a3$result$lcl)
  expect_true(a3$result$p > 0)
  expect_is(a3$result$signal, "logical")
  expect_equal(as.numeric(a3$result$signal_threshold), 1)
  expect_true(all(names(a3$params) %in% c("test_hyp",
                                          "eval_period",
                                          "null_ratio",
                                          "conf_interval",
                                          "cont_adj")))
  expect_is(a3$params$test_hyp, "character")
  expect_equal(a3$params$null_ratio, 1)
  expect_equal(a3$params$conf_interval, 0.9)
  expect_equal(a3$params$cont_adj, 0)
  expect_true(all(names(a3$data) %in% c("reference_time", "data")))
  expect_true(all(names(a3$data$data) %in% c("time_start", "time_end",
                                             "nA", "nB", "nC", "nD")))
  expect_equal(a3$data$reference_time[1], a3$data$data$time_start)
  expect_equal(a3$data$reference_time[2], a3$data$data$time_end)
  expect_equal(a3$data$data[, -c(1:2)],
               data.frame(t(colSums(a3d[nrow(a3d), c("nA", "nB", "nC", "nD")]))))
})

a3d <- data
a3d$nA2 <- ifelse(is.na(a3d$nA), 0, a3d$nA)
a4 <- bcpnn(a3d, ts_event=c("Count"="nA2"))
test_that("ts_event parameter functions as expected", {
  expect_equal(a4$result$statistic, bcpnn(a3d)$result$statistic)
  expect_equal(a4$analysis_of, NA)
})

a4 <- bcpnn(a3d, analysis_of="Testing")
test_that("ts_event parameter functions as expected", {
  expect_equal(a4$analysis_of, "Testing")
})

a4 <- bcpnn(a3d, eval_period=3)
test_that("eval_period parameter functions as expected", {
  expect_equal(a4$data$data[, -c(1:2)],
               data.frame(t(colSums(a3d[c((nrow(a3d) - 3 + 1):nrow(a3d)),
                                        c("nA", "nB", "nC", "nD")]))))
  expect_error(bcpnn(a3d, eval_period=as.integer(nrow(a3d) + 1)))
  expect_error(bcpnn(a3d, eval_period=0))
  expect_error(bcpnn(a3d, eval_period=2.5))
  expect_error(bcpnn(a3d, eval_period=nrow(a3d) + 1))
})

a4 <- bcpnn(a3d, null_ratio=2)
test_that("null_ratio parameter functions as expected", {
  expect_error(bcpnn(a3d, null_ratio=0.1))
  expect_error(bcpnn(a3d, null_ratio=0))
  expect_error(bcpnn(a3d, null_ratio=-1))
  expect_is(bcpnn(a3d, null_ratio=2), "mdsstat_test")
  expect_is(bcpnn(a3d, null_ratio=4), "mdsstat_test")
  expect_equal(a4$params$null_ratio, 2)
})

a4 <- bcpnn(a3d, conf_interval=0.95)
test_that("conf_interval parameter functions as expected", {
  expect_error(bcpnn(a3d, conf_interval=0))
  expect_error(bcpnn(a3d, conf_interval=1))
  expect_error(bcpnn(a3d, conf_interval=-.01))
  expect_error(bcpnn(a3d, conf_interval=1.01))
  expect_is(bcpnn(a3d, conf_interval=0.10), "mdsstat_test")
  expect_is(a4, "mdsstat_test")
  expect_equal(a4$params$conf_interval, 0.95)
  expect_equal(a4$params$test_hyp,
               "2.5% quantile of the posterior distribution > 1")
})

a4 <- bcpnn(a3d, quantiles=c(.1, .2, .3))
test_that("quantiles parameter functions as expected", {
  expect_error(bcpnn(a3d, quantiles=c(0, .1, .2)))
  expect_error(bcpnn(a3d, quantiles=c(.1, .2, 1)))
  expect_error(bcpnn(a3d, quantiles=c(.1, .2, -1)))
  expect_error(bcpnn(a3d, quantiles=c(.1, .2, 2)))
  expect_error(bcpnn(a3d, quantiles=c(0)))
  expect_error(bcpnn(a3d, quantiles=c(1)))
  expect_error(bcpnn(a3d, quantiles=c(2)))
  expect_error(bcpnn(a3d, quantiles=c(-1)))
  expect_is(bcpnn(a3d, quantiles=c(.5)), "mdsstat_test")
  expect_error(bcpnn(a3d, quantiles=NA))
  expect_is(bcpnn(a3d, quantiles=NULL), "mdsstat_test")
  expect_is(a4, "mdsstat_test")
  expect_equal(length(a4$result$quantiles), 3)
})

a4 <- bcpnn(a3d, cont_adj=1)
test_that("cont_adj parameter functions as expected", {
  expect_equal(unlist(a3d[nrow(a3d), c("nA", "nB", "nC", "nD")]) + 1,
               unlist(a4$data$data[, -c(1:2)]))
  expect_error(bcpnn(a3d, cont_adj=-1))
  expect_error(bcpnn(a3d, cont_adj=NA))
  expect_error(bcpnn(a3d, cont_adj=NULL))
  expect_error(bcpnn(a3d, cont_adj="foo"))
  expect_is(a4, "mdsstat_test")
  expect_equal(a4$params$cont_adj, 1)
})
