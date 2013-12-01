JEKYLL = bundle exec jekyll

run:
	$(JEKYLL) serve -w

convert:
	cd imgs; make

todo:
	grep "TODO" docs/*.md
