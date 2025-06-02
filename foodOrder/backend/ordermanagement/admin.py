from django.contrib import admin

# Register your models here.

from .models import Restaurant, FoodItem, Category, Order, OrderItem, Review, Profile

admin.site.register(Restaurant)
# admin.site.register(FoodItem)
admin.site.register(Category)
admin.site.register(Order)
admin.site.register(OrderItem)
admin.site.register(Review)
# admin.site.register(Ingredient)
admin.site.register(Profile)
from django.contrib import admin
from django.utils.html import format_html
from .models import Restaurant, FoodItem, Category, Order, OrderItem, Review, Profile

class FoodItemAdmin(admin.ModelAdmin):
    list_display = ('name', 'restaurant', 'price', 'image_tag')  # show image in list
    readonly_fields = ('image_tag',)  # show image preview inside detail view

    def image_tag(self, obj):
        if obj.image:
            return format_html('<img src="{}" width="60" height="60" />', obj.image.url)
        return "No Image"
    image_tag.short_description = 'Image'  # sets the column name

admin.site.register(FoodItem, FoodItemAdmin)
