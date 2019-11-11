from django.test import TestCase
from . import views
from .models import People
from datetime import date
from .views import Helpers

# Create your tests here.
class PersonDetailTests(TestCase):
    def setUp(self):
        People.objects.create(username='noname', date_of_birth='1999-01-20')
        People.objects.create(username='somename', date_of_birth='2015-01-20')

    def test_person_username(self):
        person = People.objects.get(username='noname')
        expected_username = f'{person.username}'
        self.assertEquals(expected_username, 'noname')

    def test_person_date(self):
        person = People.objects.get(username='somename')
        expected_date_of_birth = f'{person.date_of_birth}'
        self.assertEquals(expected_date_of_birth, '2015-01-20')

class ViewHelperTests(TestCase):
    def setUp(self):
        today = date.today()
        People.objects.create(username='noname', date_of_birth='1999-01-20')
        People.objects.create(username='somename', date_of_birth='2005-08-14')
        People.objects.create(username='luckyname', date_of_birth=today)

    def test_slit_date(self):
        person = People.objects.get(username='somename')
        date_of_birth = f'{person.date_of_birth}'
        splitted_date = Helpers().split_date(date_of_birth)
        self.assertTrue(len(splitted_date), 3)
        self.assertEquals(splitted_date[0], "2005")
        self.assertEquals(splitted_date[1], "08")
        self.assertEquals(splitted_date[2], "14")

    def test_birthday_today(self):
        test_subject_one = People.objects.get(username='luckyname')
        days_to_birthday = Helpers().birthday_due_in(test_subject_one)
        self.assertEquals(days_to_birthday, 0) # zero days to birthday == today

    def test_get_date_from_string(self):
        date_type = Helpers().get_date_from_string("2019-10-30")
        self.assertTrue(type(date_type), date)
    
    def test_get_date_from_int(self):
        generated_date = Helpers().get_date_from_int(2000, 5, 13)
        expected_date = Helpers().get_date_from_string("2000-5-13")
        self.assertEquals(expected_date, generated_date)
        self.assertTrue(type(generated_date), date)
        self.assertTrue(type(expected_date), date)

    def test_this_year_birthday(self):
        person = People.objects.get(username='noname')
        date_of_birth = f'{person.date_of_birth}'
        generated_this_year_birthday = Helpers().get_this_year_birthday_from(date_of_birth)
        expected_this_year_birthday = Helpers().get_date_from_string("2019-01-20")
        self.assertEquals(expected_this_year_birthday, generated_this_year_birthday)

    def test_get_next_birthday(self):
        person = People.objects.get(username='somename')
        date_of_birth = f'{person.date_of_birth}'
        this_year_birthday = Helpers().get_this_year_birthday_from("2005-08-14")
        expected_next_birthday = Helpers().get_date_from_string("2020-08-14")
        generated_next_birthday = Helpers().get_next_birthday_from(this_year_birthday)
        self.assertEquals(expected_next_birthday, generated_next_birthday)

    def test_born_today(self):
        person = People.objects.get(username='luckyname')
        birthday_today = Helpers().get_date_from_string(f'{person.date_of_birth}')
        is_born_today = Helpers().is_born_today_or_in_future(birthday_today)
        self.assertTrue(is_born_today)

