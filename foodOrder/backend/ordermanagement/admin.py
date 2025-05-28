from django.contrib import admin

# Register your models here.

from .models import Restaurant, FoodItem, Category, Order, OrderItem, Review, Profile

admin.site.register(Restaurant)
admin.site.register(FoodItem)
admin.site.register(Category)
admin.site.register(Order)
admin.site.register(OrderItem)
admin.site.register(Review)
admin.site.register(Profile)
