import pystac

cat = pystac.read_file("24ktyt_w/catalog.json")

cat.describe()

cat.validate_all()
