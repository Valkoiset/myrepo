pairs(LifeCycleSavings, panel = panel.smooth,
      main = "LifeCycleSavings data")


plot(sr~dpi, xlim = c(0, 5000), xlab = 'Real Per-Capita Disposable Income', ylab = 'Aggregate Personal Savings', main = 'Intercountry Life-Cycle Savings Data', data = LifeCycleSavings)
with(LifeCycleSavings, text(sr~dpi, labels = row.names(LifeCycleSavings), pos = 4))

plot(sr~pop15, xlim = c(0, 70), xlab = 'population younger than 15', ylab = 'Aggregate Personal Savings', main = 'Distribution of savings according to proportion of people under 15', data = LifeCycleSavings)
with(LifeCycleSavings, text(sr~pop15, labels = row.names(LifeCycleSavings), pos = 4))

plot(sr~pop75, xlim = c(0, 8), xlab = 'population over than 75', ylab = 'Aggregate Personal Savings', main = 'Distribution of savings according to proportion of people over 75', data = LifeCycleSavings)
with(LifeCycleSavings, text(sr~pop75, labels = row.names(LifeCycleSavings), pos = 4))

plot(sr~ddpi, xlim = c(0, 20), xlab = 'numeric growth rate of dpi', ylab = 'Aggregate Personal Savings', main = 'percentage increase of income', data = LifeCycleSavings)
with(LifeCycleSavings, text(sr~ddpi, labels = row.names(LifeCycleSavings), pos = 4))