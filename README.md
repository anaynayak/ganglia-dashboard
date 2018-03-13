Ganglia Dashboard
=================

An alternative to Ganglia views.

Copy config.example.yml to config.yml and tweak it based on your Ganglia setup.

#### Why on earth would you build this?


We use Ganglia for monitoring and I have had a hard time trying to get Ganglia views to work. I don't grok php nor the 1980's images from rrd. This is a attempt to view multiple metrics across multiple hosts in a quick way.

#### So how do I use this?

```
cp lib/config.example.yml lib/config.yml
bundle install
foreman start
open http://localhost:5600/dashboard
```

#### Features

* Friendly graph urls. If you need to see a larger image, simply switch size to xlarge.
* Parameters passed to the dashboard are merged with every graph. So to switch the image size for all images, just pass `http://localhost:5600/dashboard?size=large`
* Generate a PDF report by running `thor ganglion:export`

#### Example
![](https://github.com/anaynayak/ganglia-dashboard/raw/master/images/gangliadashboard.png)
