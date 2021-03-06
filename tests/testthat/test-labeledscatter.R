context("Labeled scatter")
library(flipChartTests)
library(flipStandardCharts)

suppressWarnings(RNGversion("3.5.3"))
set.seed(12358)
dat <- matrix(rnorm(24), 12, 2,
              dimnames=list(stringi::stri_rand_strings(12, 6), c("X", "Y")))
zgroup <- rep(LETTERS[1:3], 4)
logos <- sprintf("https://displayrcors.displayr.com/images/%s_grey.svg",
                 c("apple", "soup", "bread", "car", "chicken", "rocket",
                   "sickperson", "thumbsup", "elephant", "tree", "weight", "tools"))

test_that("Max labels", {
    expect_warning(pp <- LabeledScatter(dat, scatter.max.labels = 5), "Some labels have been hidden")
    expect_true(TestWidget(pp, "labeledscatter-maxlabels", mouse.click = TRUE))
})

test_that("Logos",  {
    expect_error(pp <- LabeledScatter(dat, logos = logos), NA)
    expect_true(TestWidget(pp, "labeledscatter-logos", mouse.click = TRUE))
    expect_error(pp <- LabeledScatter(dat, logos = paste(logos, collapse=","), logo.size = 0.2), NA)
    expect_true(TestWidget(pp, "labeledscatter-logos-resized", mouse.click = TRUE))
    expect_error(pp <- LabeledScatter(dat, logos = c("Typo", logos[-1]), logo.size = 0.2), NA)
    expect_true(TestWidget(pp, "labeledscatter-logos-typo", mouse.click = TRUE))
})

test_that("Trend lines", {
    expect_error(pp <- LabeledScatter(dat, trend.line = TRUE), NA)
    expect_true(TestWidget(pp, "labeledscatter-trend-single", mouse.click = TRUE))
    expect_error(pp <- LabeledScatter(dat, scatter.colors = zgroup,
                                      scatter.colors.as.categorical = T, trend.line = TRUE), NA)
    expect_true(TestWidget(pp, "labeledscatter-trend-groups", mouse.click = TRUE))
    expect_error(pp <- LabeledScatter(list(dat, dat+0.5, dat+1), trend.line = TRUE), NA)
    expect_true(TestWidget(pp, "labeledscatter-trend", mouse.click = TRUE))
    expect_warning(pp <- LabeledScatter(list(dat, dat+0.5, dat+1), trend.line = FALSE), "Tables have been automatically assigned names")
    expect_true(TestWidget(pp, "labeledscatter-notrend", mouse.click = TRUE))
    expect_error(pp <- LabeledScatter(list(dat, dat+rnorm(24)), trend.line = TRUE, logos = logos, logo.size = 0.2), NA)
    expect_true(TestWidget(pp, "labeledscatter-trend-logos", mouse.click = TRUE))
})
