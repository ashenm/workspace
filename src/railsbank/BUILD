docker_image(
    name="docker",
    repository="ashenm/workspace",
    dependencies=[":filesystem", "src/latest:docker"],
    image_tags=["railsbank"],
)

files(
    name="filesystem",
    sources=["filesystem/**"],
)
