context("calculateDistance AppsilonRecruitmentTask2020")

myData <- readRDS(system.file("data/ships_data/1960.RDS", package="AppsilonRecruitmentTask2020"))

test_that("calculateDistance to the same point", {
  expect_equal(calculateDistance(rbind(myData[1, ], myData[1, ]))$distance, 0)
  expect_equal(calculateDistance(rbind(myData[1, ], myData[1, ]))$difftime, 0)
})

test_that("calculateDistance to different point", {
  expect_true(calculateDistance(myData[1:2, ])$distance >= 0)
  expect_true(calculateDistance(myData[1:2, ])$difftime > 0)
})

test_that("calculateDistance order regsiters based on datetime field", {
  expect_equal(calculateDistance(myData[2:1, ]), calculateDistance(myData[1:2, ]))
})