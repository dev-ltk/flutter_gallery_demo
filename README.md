# flutter_gallery_demo

Demonstration of coupling InteractiveViewer and PagaView in Flutter.

It can achieve a behaviour which the user's single tap actions are recognized as pan action on a zoomed in page. Once the zoomed in page reached its boundaries, the users can swipe to other pages by a horizontal swipe.

## Limitations

1. The action must stop once at the boudaries before it can swipe to other pages. Beyond the stop, any successive horizontal swipe will be recognized as a swipe to other pages but not pan inside the page until the user cancels the swipe. If the successive action beyond the stop is a gesture zoom in or out while keeping the page at the boundaries, the next horizontal swipe is still recognized as a swip to other pages.
2. If the user cancelled the swipe, there is a delay that the action can be re-recognized as panning the page instead of a horizontal swipe to change pages.
