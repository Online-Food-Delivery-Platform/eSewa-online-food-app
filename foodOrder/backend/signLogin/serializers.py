from rest_framework import serializers
from django.contrib.auth.models import User

class UserSignupSerializer(serializers.ModelSerializer):
    role = serializers.ChoiceField(
        choices=[('admin', 'Admin'), ('user', 'User')],
        write_only=True,
        default='user'
    )

    class Meta:
        model = User
        fields = ['username', 'email', 'password', 'role']
        extra_kwargs = {
            'password': {'write_only': True}
        }

    def create(self, validated_data):
        role = validated_data.pop('role', 'user')
        user = User.objects.create_user(**validated_data)
        if role == 'admin':
            user.is_staff = True
            user.is_superuser = True
            user.save()
        return user


class UserLoginSerializer(serializers.Serializer):
    email = serializers.EmailField()
    password = serializers.CharField(write_only=True)
