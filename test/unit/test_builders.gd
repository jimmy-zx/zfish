extends GutTest

var targets = [
    preload("res://modules/dup_builder/dup_builder.tscn"),
    preload("res://modules/entity/entity.tscn"),
    preload("res://modules/env/env.tscn"),
    preload("res://modules/image/image.tscn"),
    preload("res://modules/indian_leaf_fish/indian_leaf_fish.tscn"),
    preload("res://modules/shrimp/shrimp.tscn"),
    preload("res://modules/stage/stage_builder.tscn"),
    preload("res://modules/stage/scene_builder.tscn"),
    preload("res://modules/timer/timer.tscn"),
    preload("res://modules/zebra_fish/zebra_fish.tscn"),
]


func test_builder_attrs():
    for cls in targets:
        var inst: Node2D = cls.instantiate()
        var builder: Window = inst.get_node("Builder")
        assert_false(builder.visible, cls.resource_path)
        assert_true(builder.unresizable, cls.resource_path)
        assert_eq(builder.initial_position, Window.WindowInitialPosition.WINDOW_INITIAL_POSITION_CENTER_PRIMARY_SCREEN, cls.resource_path)
        assert_gt(builder.close_requested.get_connections().size(), 0, cls.resource_path)
        assert_false(builder.title.is_empty(), cls.resource_path)
