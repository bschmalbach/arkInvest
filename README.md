# Europeanized ARK ETF Investment Portfolio 

The ARK ETFs (https://ark-funds.com/active-etfs) are exchange-traded funds actively managed by Catherine Wood and ARK Invest.
They focus on high-growth, high-innovation companies and have performed spectacularly well in the recent years - and particularly since the Covid crash.

In this script, I present the Europeanized version of the portfolio using the following steps. It can be updated daily (or whatever time interval suits your needs):

<ul>
<li>Download the most recent list of holdings from the ARK website</li>
<li>Retain only those assets that are weighted at least 2% in any one fund</li>
<li>Remove FAAMG stocks (too big for my taste)</li>
<li>For the next steps to work, you need a broker that offers fractional shares (or you need to invest the least common multiple, if that is an acceptable savings rate ;) )</li>
<li>Check the tickers.csv file and mark those stocks with "1" that are available in fractions. The others should be 0. I did this for Investing 212.</li>
<li>Drop unavailable stocks</li>
<li>Use the root of the average weight of a stock times the number of occurences across the various ARK ETFs (this is my approach for accounting for synergy effects)</li>
<li>Check the remaining stocks</li>
<li>Use all remaining ones for your portfolio or pick any subset. I chose the top 20 here</li>
</ul>



<b>Top 20 stocks by weight in the composite Europeanized ARK ETF (or ARK20)</b>

<img src="https://github.com/bschmalbach/arkInvest/blob/master/Rplot.png">

Some of these decisions are subjective and obviously none of this is financial advise.
