from django.urls import path,include
from . import views
from rest_framework.routers import DefaultRouter
from .views import RestaurantViewSet, FoodItemViewSet


# Create and register viewsets
router = DefaultRouter()
router.register(r'restaurants', RestaurantViewSet, basename='restaurant')
router.register(r'fooditems', FoodItemViewSet, basename='fooditem')


urlpatterns = [
    path('', include(router.urls)),
    path('orders/', views.list_my_orders, name='my-orders'),
    path('orders/create/', views.create_order, name='create-order'),
    path('orders/<int:order_id>/', views.track_order, name='track-order'),
    path('admin/orders/', views.list_all_orders, name='admin-orders'),
    path('admin/orders/<int:order_id>/update/', views.update_order_status, name='update-order-status'),
    path('restaurants/', views.list_restaurants, name='list-restaurants'),
]
