# flutter_gallery_demo

Demonstration of coupling InteractiveViewer and PagaView in Flutter.

It can achieve a behaviour which the user's single tap actions are recognized as pan action on a zoomed in page. Once the zoomed in page reached its boundaries, the users can swipe to other pages by a horizontal swipe.

## Limitations

1. The action must stop once at the boudaries before it can swipe to other pages.
2. If the user cancelled the swipe, there is a delay that the action can be re-recognized as panning the page instead of a horizontal swipe to change pages.
