from django.urls import path
from . import views

urlpatterns = [
    path('orders/', views.list_my_orders, name='my-orders'),
    path('orders/create/', views.create_order, name='create-order'),
    path('orders/<int:order_id>/', views.track_order, name='track-order'),
    path('admin/orders/', views.list_all_orders, name='admin-orders'),
    path('admin/orders/<int:order_id>/update/', views.update_order_status, name='update-order-status'),
]
