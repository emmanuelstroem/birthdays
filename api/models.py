from django.db import models

# Create your models here.
class People(models.Model):
    username = models.CharField(blank=False, max_length=100)
    date_of_birth = models.DateField()
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ['created_at', 'date_of_birth']

    def __str__(self):
        return '%s ' % (self.username)