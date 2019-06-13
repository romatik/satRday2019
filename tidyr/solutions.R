library(tidyr)

# Pivoting ----------------------------------------------------------------

# Anscombe -----------------------------------------------------------------
## Convert Anscombe quartet into a tidy form
anscombe

res <- data.frame(stringsAsFactors = FALSE,
                  set = c("1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "2",
                          "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "3", "3",
                          "3", "3", "3", "3", "3", "3", "3", "3", "3", "4", "4", "4", "4",
                          "4", "4", "4", "4", "4", "4", "4"),
                  x = c(10, 8, 13, 9, 11, 14, 6, 4, 12, 7, 5, 10, 8, 13, 9, 11, 14, 6,
                        4, 12, 7, 5, 10, 8, 13, 9, 11, 14, 6, 4, 12, 7, 5, 8, 8, 8, 8,
                        8, 8, 8, 19, 8, 8, 8),
                  y = c(8.04, 6.95, 7.58, 8.81, 8.33, 9.96, 7.24, 4.26, 10.84, 4.82,
                        5.68, 9.14, 8.14, 8.74, 8.77, 9.26, 8.1, 6.13, 3.1, 9.13,
                        7.26, 4.74, 7.46, 6.77, 12.74, 7.11, 7.81, 8.84, 6.08, 5.39, 8.15,
                        6.42, 5.73, 6.58, 5.76, 7.71, 8.84, 8.47, 7.04, 5.25, 12.5, 5.56,
                        7.91, 6.89)
)

anscombe %>%
  pivot_longer(everything(),
               names_to = c(".value", "set"),
               names_pattern = "(.)(.)"
  )

# Panel data -----------------------------------------------------------------
## This is panel data:
## - `x` is ID
## - `a` and `b` are exposures
## - `y` and `z` are measurements
## measurement an
pnl <- tibble(
  x = 1:4,
  a = c(1, 1,0, 0),
  b = c(0, 1, 1, 1),
  y1 = rnorm(4),
  y2 = rnorm(4),
  z1 = rep(3, 4),
  z2 = rep(-2, 4),
)
pnl

# Find a way to convert `pnl` to a following output
res <- data.frame(stringsAsFactors = FALSE,
                  x = c(1L, 1L, 2L, 2L, 3L, 3L, 4L, 4L),
                  a = c(1, 1, 1, 1, 0, 0, 0, 0),
                  b = c(0, 0, 1, 1, 1, 1, 1, 1),
                  time = c("1", "2", "1", "2", "1", "2", "1", "2"),
                  y = c(-1.03500781308911, 0.217593146852263, 2.67192019275096,
                        -0.0210247618072284, 0.740107984564996, 0.752348431454166,
                        -0.560852848012202, -0.871535583008563),
                  z = c(3, -2, 3, -2, 3, -2, 3, -2)
)
res

pnl %>%
  pivot_longer(
    -c(x, a, b),
    names_to = c(".value", "time"),
    names_pattern = "(.)(.)"
  )


# Bakers -----------------------------------------------------------------
# This table shows results of guessing what is inside of a recipe by four bakers
juniors_multiple <- tribble(
  ~ "baker", ~"score_1", ~"score_2", ~"score_3", ~ "guess_1", ~"guess_2", ~"guess_3",
  "Emma", 1L,   0L, 1L, "cinnamon",   "cloves", "nutmeg",
  "Harry", 1L,   1L, 1L, "cinnamon",   "cardamom", "nutmeg",
  "Ruby", 1L,   0L, 1L, "cinnamon",   "cumin", "nutmeg",
  "Zainab", 0L, NA, 0L, "cardamom", NA_character_, "cinnamon"
)

# Find a way to create three new columns with following info:
# - first is order (1/2/3) –> these are the numbers at end of my column names
# - second is score (0/1/NA)
# - third is guess (cinnamon/cloves/nutmeg/NA)
juniors_multiple %>%
  pivot_longer(-baker,
               names_to = c(".value", "order"),
               names_sep = "_"
  )

# Now make order an integer
juniors_multiple %>%
  pivot_longer(-baker,
               names_to = c(".value", "order"),
               names_sep = "_",
               names_ptypes = list(
                 order = integer()
               )
  )

# Now make order a factor
juniors_multiple %>%
  pivot_longer(-baker,
               names_to = c(".value", "order"),
               names_sep = "_",
               names_ptypes = list(
                 order = factor(levels = c(1, 2, 3))
               )
  )


# pivot_wider 1 -----------------------------------------------------------------
df <- tibble(mycode = c('A','A','A','B','B'),
             mytime = c(ymd('2018-01-02',
                            '2018-01-03',
                            '2018-01-04',
                            '2018-01-02',
                            '2018-01-05')),
             var1 = c(1,2,3,4,5),
             othervar = c(10,20,30,10,20))

res <- data.frame(
  mytime = c("2018-01-02", "2018-01-03", "2018-01-04", "2018-01-05"),
  var1_A = c(1, 2, 3, NA),
  var1_B = c(4, NA, NA, 5),
  othervar_A = c(10, 20, 30, NA),
  othervar_B = c(10, NA, NA, 20)
)

res <- df %>%
  pivot_wider(names_from = mycode, values_from = c(var1, othervar))


# pivot_wider 2 -----------------------------------------------------------------
df <- data.frame(Sex = c("M","F","M","M","F","F"),
                 RSVP = c("Y","N","N","Y","N","Y"),stringsAsFactors = FALSE)

## find out how many people (both absolute number and proportion) per gender replied
## hint: use `prop.table`
res <- data.frame(stringsAsFactors = FALSE,
                  Sex = c("F", "M"),
                  n_N = c(2L, 1L),
                  n_Y = c(1L, 2L),
                  prop_N = c(0.666666666666667, 0.333333333333333),
                  prop_Y = c(0.333333333333333, 0.666666666666667)
)

res <- df %>%
  count(Sex, RSVP) %>%
  group_by(Sex) %>%
  mutate(prop = prop.table(n)) %>%
  pivot_wider(names_from = RSVP, values_from = c(n, prop))


# Multiple choice -----------------------------------------------------------------
# This data shows results of a survey with multiple choices
multi <- tribble(
  ~id, ~choice1, ~choice2, ~choice3,
  1, "A", "B", "C",
  2, "C", "B",  NA,
  3, "D",  NA,  NA,
  4, "B", "D",  NA
)

# Find a way to convert into a form where each row corresponds to a user
# either choosing or not choosing an option, i.e.:
res <- data.frame(
  id = c(1, 2, 3, 4),
  A = c(TRUE, FALSE, FALSE, FALSE),
  B = c(TRUE, TRUE, FALSE, TRUE),
  C = c(TRUE, TRUE, FALSE, FALSE),
  D = c(FALSE, FALSE, TRUE, TRUE)
)
res

res <- multi %>%
  pivot_longer(-id, values_drop_na = TRUE) %>%
  mutate(checked = TRUE) %>%
  pivot_wider(
    id_cols = id,
    names_from = value,
    values_from = checked,
    values_fill = list(checked = FALSE)
  )


# World Bank -----------------------------------------------------------------
## World Bank data
world_bank_pop

## Convert this data to a tidy format

## Example of output:
res <- data.frame(stringsAsFactors = FALSE,
                  country = c("ABW", "ABW", "ABW", "ABW", "ABW", "ABW"),
                  area = c("URB", "URB", "URB", "URB", "URB", "URB"),
                  year = c("2000", "2001", "2002", "2003", "2004", "2005"),
                  TOTL = c(42444, 43048, 43670, 44246, 44669, 44889),
                  GROW = c(1.18263237130859, 1.41302121757747, 1.4345595310351,
                           1.31036043903253, 0.951477683657806, 0.491302714501917)
)

res <- world_bank_pop %>%
  pivot_longer(`2000`:`2017`, names_to = "year", values_to = "value") %>%
  separate(indicator, c(NA, "area", "variable")) %>%
  pivot_wider(names_from = variable, values_from = value)


# Rectangling -------------------------------------------------------------
films <- tibble(
  character = c("Toothless", "Dory"),
  metadata = list(
    list(
      species = "dragon",
      color = "black",
      films = c(
        "How to Train Your Dragon",
        "How to Train Your Dragon 2",
        "How to Train Your Dragon: The Hidden World"
      )
    ),
    list(
      species = "clownfish",
      color = "blue",
      films = c("Finding Nemo", "Finding Dory")
    )
  )
)
films


# example -----------------------------------------------------------------
# Turn all components of metadata into columns
films %>% unnest_wider(metadata)


# example -----------------------------------------------------------------
# Extract only species, first and third films from metadata
films %>% hoist(metadata,
                species = "species",
                first_film = list("films", 1L),
                third_film = list("films", 3L)
)

# example -----------------------------------------------------------------
# flattern `films` dataset entirely (no list columns)
films %>%
  unnest_wider(metadata) %>%
  unnest_longer(films)

